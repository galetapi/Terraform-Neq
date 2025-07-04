# Recopilacion de nodos superiores a 50GB

import requests

#funcion convertidor texto a array
def convertTextToArray (entranceText):
    lista = []
    # Dividir el texto de entrada en líneas
    for line in entranceText.split("\n"):
        # Dividir cada línea en elementos individuales
        elements = line.strip().split()
        lista.append(elements)
    # Elimina el primer y último elemento de la lista.
    lista = lista [1:(len(lista)-1)]
    return lista

#login
def getResponse (url, password):
    if password:
        internal_response =requests.get(url, auth=("MasterOS", "0p3nSctM4ster*"))
    else:
        internal_response = requests.get(url)

    if internal_response.status_code == 200:
        # The request was successful
        print("Request successful")
        return internal_response
    else:
        # The request failed
        print("Error: " + str(internal_response.status_code))


def separar_tamanos(registros):
    tb = []
    gb = []
    altagb = []

    for registro in registros:
        if len(registro) > 5:  # Asegurarse de que hay suficiente información en posicion 5
            tamaño = registro[5]  # Obtener el tamaño
            
            # Verificar si el tamaño tiene el formato esperado
            if len(tamaño) >= 3 and tamaño[-2:].lower() in ['tb', 'gb', 'kb', 'mb']:  #len(tamaño) >= 3 se asegura caracteres 0kg, tamaño[-2:] ultimo caracteres kg, .lower() asegura minuscula y mayuscula
                valor_str = tamaño[:-2]  # Obtener el valor 0
                unidad = tamaño[-2:].lower()  # Obtener la unidad kg

                try:
                    valor = float(valor_str)  # Convirtio el valor a float (0.0)
                    # Clasificar en la lista correspondiente
                    if unidad == 'tb':
                        tb.append(valor)
                    elif unidad == 'gb':
                        gb.append(valor)
                        if valor > 55:
                            altagb.append(registro) # Almacenar registro si supera 55 GB
                except ValueError:
                    print(f"Valor no convertible a float: '{valor_str}' en registro {registro}")
    return tb, gb, altagb

# Función para crear y enviar métricas a Dynatrace
def sendDynatraceMetric(metric):
    url = 'https://iyl01250.live.dynatrace.com/api/v2/metrics/ingest'
    headers = {
        'Authorization': 'Api-Token ("token_dyna")',
        'Content-Type': 'text/plain'
    }
    response = requests.post(url, headers=headers, data=metric)
    if response.status_code in [200, 201, 202]:
        return response
    else:
        print(f"Error sending metric: {response.status_code}")
        return None


# Función para enviar métricas para los registros que superan 55 GB
def sendMetricsForLargeData(altagb, cluster_name):
    altagb_count = len(altagb)
    metrica_altagb_count = f"custom.opensearch.clusternodes.altagb.count,cluster={cluster_name} {altagb_count}"
    sendDynatraceMetric(metrica_altagb_count)  # Enviar la métrica de la cantidad de registros grandes o en este caso mayor a 55GB

####validacion de codigo anterior para la peticion de extraccion de la informacion #######
##########################################################################################

#def main():
context = "_cat/shards?v"  
url_list = ["https://vpc-es-pdn-co-6-0-s3gehnpnazjvk6oxqryt2oq3xq.us-east-1.es.amazonaws.com/", "https://vpc-apt0002-os-pdn-co-01-vdql7pb6ek2ue5jzm4y6xmcr4u.us-east-1.es.amazonaws.com/"]

# Lista donde vamos a almacenar las respuestas combinadas de las dos url
combined_array = []

for element in url_list:
    cluster_name = element[8:].replace(".us-east-1.es.amazonaws.com/","")
    print (cluster_name)
    if cluster_name == "vpc-apt0002-os-pdn-co-01-vdql7pb6ek2ue5jzm4y6xmcr4u":
        password = True
    else:
        password = False
    complete_url = element+context
    print (complete_url)
    response = getResponse(complete_url, password)
    # print(response.text)
    if response:
        arreglo = convertTextToArray(response.text)
        # print(f"Datos recibidos del cluster {cluster_name}: {arreglo}")
        combined_array.extend(arreglo)
    _, _, altagb = separar_tamanos(combined_array)
    sendMetricsForLargeData(altagb, cluster_name) 

# tb, gb, kb, mb, nobyte, altagb = separar_tamanos(combined_array)
tb, gb, altagb = separar_tamanos(combined_array)

print("Total de Registros context shards",len(combined_array)) #debe ir hasta aca para no perder la traza 

# Ordenar registros descandente que superan 50 GB(visual)
altagb_sorted = sorted(altagb, key=lambda x: float(x[5][:-2]), reverse=True)

# Imprimir los registros que superan 50 GB en formato tabla
for sublista in altagb_sorted:
    print(sublista, "\t")
print( "Nodos mayores 55gb en shards AltosGB son un Total:", len(altagb), "\n")


