import requests
from datetime import datetime, timedelta, timezone

# Función para obtener la respuesta desde la URL
def getResponse(url):
    try:
        # Realizar la solicitud sin autenticación
        internal_response = requests.get(url)
        
        internal_response.raise_for_status()  # Verifica si hubo algún error (verifica el código de estado HTTP(2xx))
        print("Request successful")
        return internal_response
    except requests.exceptions.RequestException as e:
        print(f"Error: {e}")  # HTTPError(4xx,5xx)
        return None

# Función principal para obtener los datos de los índices creados en las últimas 24 horas
def main():
    opensearch_url = "https://vpc-es-pdn-co-6-0-s3gehnpnazjvk6oxqryt2oq3xq.us-east-1.es.amazonaws.com"
    context_indice = "_cat/indices?v&h=index,creation.date,string,store.size"  # Obtener index, fecha de creación y tamaño

    # Consulta al endpoint _cat/indices
    complete_url_indice = f"{opensearch_url}/{context_indice}"
    
    # Realizar la consulta al endpoint _cat/indices
    response_allocation = getResponse(complete_url_indice)  # Sin autenticación ahora

    # Si obtenemos la respuesta correctamente
    if response_allocation:
        lines = response_allocation.text.splitlines()

        # Eliminar la primera línea de encabezados
        lines = lines[1:]

        # Calcular las fechas de inicio y fin de las últimas 24 horas
        end_date = datetime.now(timezone.utc)
        start_date = end_date - timedelta(hours=24)

        # Inicializar la lista para almacenar los índices y su tamaño
        index_data = []
        hourly_storage = {}  # Diccionario para almacenar el tamaño total por hora

        # Iterar sobre los índices y filtrar solo los que fueron creados en las últimas 24 horas
        for line in lines:
            columns = line.split()
            if len(columns) >= 3:
                index_name = columns[0]
                creation_date = columns[1]
                store_size = columns[2]
                
                # Verificar si la fecha es un timestamp (número largo)
                if creation_date.isdigit():
                    # Convertir el timestamp en milisegundos a segundos
                    timestamp_seconds = int(creation_date) / 1000
                    creation_date_obj = datetime.fromtimestamp(timestamp_seconds, timezone.utc)

                    # Formatear la fecha a formato legible
                    creation_date_str = creation_date_obj.strftime('%Y-%m-%d %H:%M:%S')
                else:
                    # Si no es un timestamp, procesarlo como una fecha en formato ISO
                    creation_date = creation_date.rstrip('Z')  # Eliminar el sufijo 'Z' que indica UTC

                    try:
                        # Intentar convertir la fecha de creación con un formato más flexible
                        try:
                            # Intentar con fecha sin fracción de segundo
                            creation_date_obj = datetime.strptime(creation_date, '%Y-%m-%dT%H:%M:%S')
                        except ValueError:
                            # Si no tiene el formato anterior, intentar con fracción de segundo
                            creation_date_obj = datetime.strptime(creation_date, '%Y-%m-%dT%H:%M:%S.%f')
                    except ValueError:
                        # Si no se puede convertir la fecha, ignorar este índice
                        print(f"Error al procesar la fecha de creación para el índice {index_name}")
                        continue

                    # Formatear la fecha a formato legible
                    creation_date_str = creation_date_obj.strftime('%Y-%m-%d %H:%M:%S')

                # Verificar si la fecha de creación es dentro de las últimas 24 horas
                if creation_date_obj >= start_date:
                    # Convertir el tamaño de almacenamiento a GB
                    if 'gb' in store_size:
                        size_in_gb = float(store_size.replace('gb', ''))
                    elif 'mb' in store_size:
                        size_in_gb = float(store_size.replace('mb', '')) / 1024
                    else:
                        size_in_gb = 0  # Si no se puede convertir el tamaño

                    # Agregar el índice y su tamaño a la lista
                    index_data.append((index_name, creation_date_str, size_in_gb))

                    # Registrar el tamaño en el diccionario por hora, junto con el índice correspondiente
                    hour_key = creation_date_obj.replace(minute=0, second=0, microsecond=0)  # Solo considerar la hora
                    if hour_key not in hourly_storage:
                        hourly_storage[hour_key] = {"total_size": 0, "index": index_name}
                    hourly_storage[hour_key]["total_size"] += size_in_gb

                    # Si el tamaño acumulado de esa hora es mayor al máximo, actualizar el índice
                    if hourly_storage[hour_key]["total_size"] > hourly_storage[hour_key].get("total_size", 0):
                        hourly_storage[hour_key]["index"] = index_name
        
        # Ordenar la lista por tamaño (de mayor a menor)
        index_data.sort(key=lambda x: x[2], reverse=True)

        # Inicializar la variable para acumular el tamaño total
        total_size_gb = 0
        
        # Imprimir los índices ordenados y acumular el tamaño
        for index_name, creation_date_str, size_in_gb in index_data:
            total_size_gb += size_in_gb
            print(f"Índice: {index_name}, Fecha de Creación: {creation_date_str}, Tamaño: {size_in_gb:.2f} GB")

        # Imprimir el tamaño total acumulado
        print(f"\nTamaño total store de los índices creados Sherpa en las últimas 24 horas: {total_size_gb:.2f} GB\n")

        # Encontrar la hora con más almacenamiento y el índice correspondiente
        max_hour = max(hourly_storage, key=lambda x: hourly_storage[x]["total_size"])
        max_storage = hourly_storage[max_hour]["total_size"]
        index_at_max_hour = hourly_storage[max_hour]["index"]
        print(f"La hora con más almacenamiento fue {max_hour.strftime('%Y-%m-%d %H:%M:%S')} con {max_storage:.2f} GB y el índice fue {index_at_max_hour}.\n")

    else:
        print("No se pudo obtener la información de los índices.")

# Llamada a la función principal
if __name__ == "__main__":
    main()  