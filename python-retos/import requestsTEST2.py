import requests
from datetime import datetime, timedelta, timezone

# Función para obtener la respuesta desde la URL
def getResponse(url, password):
    try:
        if password:
            internal_response = requests.get(url, auth=("MasterOS", "0p3nSctM4ster*"))
        else:
            internal_response = requests.get(url)
        
        internal_response.raise_for_status()  # Verifica si hubo algún error (verifica el código de estado HTTP(2xx))
        print("Request successful")
        return internal_response
    except requests.exceptions.RequestException as e:
        print(f"Error: {e}")  # HTTPError(4xx,5xx)
        return None

# Función principal para obtener los datos de los índices
def main():
    opensearch_url = "https://vpc-es-pdn-co-6-0-s3gehnpnazjvk6oxqryt2oq3xq.us-east-1.es.amazonaws.com"
    context_indice = "_cat/indices?v"  # Endpoint correcto para obtener los índices y su información

    # Realizar la consulta al endpoint _cat/indices?v
    complete_url_indice = f"{opensearch_url}/{context_indice}"
    response_allocation = getResponse(complete_url_indice, password=True)  # Suponiendo que necesitas autenticación

    # Contador de índices
    index_counter = 0

    # Procesar la respuesta y obtener la información de los índices
    if response_allocation:
        # Imprimir los detalles de los índices CON TODAS SU ESTRUCTURA (PRUEBA COMPLETA DE INDICES)
        # print(response_allocation.text)
        
        # Aquí procesamos la respuesta para obtener los documentos y tamaño en GB
        lines = response_allocation.text.splitlines()

        # Eliminar la primera línea de encabezados
        lines = lines[1:]

        for line in lines:
            # Separar por columnas
            columns = line.split()
            if len(columns) >= 6:
                index_name = columns[2]
                doc_count = columns[6]  # Número de documentos
                store_size = columns[8]  # Tamaño del índice

                # Incrementar contador de índices
                index_counter += 1

                print(f"Índice: {index_name}, Documentos: {doc_count}, Tamaño: {store_size}")

        # Mostrar el total de índices
        print(f"\nTotal de índices: {index_counter}")
    else:
        print("No se pudo obtener la información de los índices.")

# Llamada a la función principal
if __name__ == "__main__":
    main()
