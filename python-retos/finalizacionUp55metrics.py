import requests

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

# Función para convertir el texto a un array de registros
def convertTextToArray(entranceText):
    lista = []
    for line in entranceText.split("\n"):
        elements = line.strip().split()
        lista.append(elements)
    lista = lista[1:(len(lista)-1)]  # Eliminar las primeras y últimas filas innecesarias
    return lista

# Lista donde vamos a almacenar las respuestas combinadas de las dos url shards
combined_array = []

# Función para separar tamaños en TB, GB y aquellos mayores a 55GB
def separar_tamanos(registros):

    tb, gb, altagb = [], [], []

    for registro in registros:
        if len(registro) > 5:  # Asegurarse de que hay suficiente información en la posición 5
            tamaño = registro[5]
            if len(tamaño) >= 3 and tamaño[-2:].lower() in ['tb', 'gb']:  # Revisar unidades
                valor_str = tamaño[:-2]  # Obtener valor numérico
                unidad = tamaño[-2:].lower()  # Obtener la unidad
                try:
                    valor = float(valor_str)
                    if unidad == 'tb':
                        tb.append(valor)
                    elif unidad == 'gb':
                        gb.append(valor)
                        if valor > 55:  # Identificar registros mayores a 55 GB
                            altagb.append(registro)
                except ValueError:
                    print(f"Valor no convertible a float: '{valor_str}' en registro {registro}")
    return tb, gb, altagb
# tb, gb, altagb = separar_tamanos(combined_array)


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

# Función para procesar el resultado y enviar las métricas
def createDynatraceMessage(array, cluster_name):
    count_uwarm = 0
    count_hot = 0
    for element in array:
        shards_count = element[0]
        disk_total = element[4]
        if disk_total == "20tb":
            disk_total = disk_total.replace("tb", "")
            disk_used = element[2].replace("tb", "")
            disk_available = element[3].replace("tb", "")
            node_type = "ultrawarm"
            count_uwarm += 1
        else:
            disk_total = disk_total.replace("gb", "")
            disk_used = element[2].replace("gb", "")
            disk_available = element[3].replace("gb", "")
            node_type = "hot"
            count_hot += 1
        
        disk_used_percentage = element[5]
        node_name = element[8]
        
        # Enviar las métricas a Dynatrace
        metrica_shards = "custom.opensearch.shardscount,cluster="+cluster_name+",node="+node_name+",type="+node_type+" "+shards_count
        sendDynatraceMetric(metrica_shards)
        metrica_disk_used = "custom.opensearch.diskused,cluster="+cluster_name+",node="+node_name+",type="+node_type+",total_disk="+disk_total+" "+disk_used
        sendDynatraceMetric(metrica_disk_used)
        metrica_disk_available = "custom.opensearch.diskavailable,cluster="+cluster_name+",node="+node_name+",type="+node_type+",total_disk="+disk_total+" "+disk_available
        sendDynatraceMetric(metrica_disk_available)
        metrica_disk_used_perc = "custom.opensearch.diskusedpercentage,cluster="+cluster_name+",node="+node_name+",type="+node_type+",total_disk="+disk_total+" "+disk_used_percentage
        sendDynatraceMetric(metrica_disk_used_perc)

    total_nodes_count = count_uwarm + count_hot
    metrica_count_uwarm = "custom.opensearch.clusternodes.ultrawarm.count,cluster="+cluster_name+" "+str(count_uwarm)
    sendDynatraceMetric(metrica_count_uwarm)
    metrica_count_hot = "custom.opensearch.clusternodes.hot.count,cluster="+cluster_name+" "+str(count_hot)
    sendDynatraceMetric(metrica_count_hot)
    metrica_count_allnodes = "custom.opensearch.clusternodes.allnodes.count,cluster="+cluster_name+" "+str(total_nodes_count)
    sendDynatraceMetric(metrica_count_allnodes)

# Función para enviar métricas para los registros que superan 55 GB
def sendMetricsForLargeData(altagb, cluster_name):
    altagb_count = len(altagb)
    print("MetricasNodos mayores 55gb en shards AltosGB son un Total:",len(altagb)) #validacion cantidad nodos
    metrica_altagb_count = f"custom.opensearch.clusternodes.altagb.count,cluster={cluster_name} {altagb_count}"
    sendDynatraceMetric(metrica_altagb_count)  # Enviar la métrica de la cantidad de registros grandes

# Función principal para obtener los datos de ambos contextos
def main():
    url_list = ["https://vpc-es-pdn-co-6-0-s3gehnpnazjvk6oxqryt2oq3xq.us-east-1.es.amazonaws.com/", 
                "https://vpc-apt0002-os-pdn-co-01-vdql7pb6ek2ue5jzm4y6xmcr4u.us-east-1.es.amazonaws.com/"]
    
    context_allocation = "_cat/allocation?v"
    context_shards = "_cat/shards?v"

    for element in url_list:
        cluster_name = element[8:].replace(".us-east-1.es.amazonaws.com/", "")
        print(f"Cluster: {cluster_name}")
        
        # Determinar si se necesita autenticación
        password = True if cluster_name == "vpc-apt0002-os-pdn-co-01-vdql7pb6ek2ue5jzm4y6xmcr4u" else False
        
        # Solicitar y procesar datos para "_cat/allocation?v"
        complete_url_allocation = element + context_allocation
        response_allocation = getResponse(complete_url_allocation, password)
        if response_allocation:
            arreglo_allocation = convertTextToArray(response_allocation.text)
            createDynatraceMessage(arreglo_allocation, cluster_name)
         
        # Solicitar y procesar datos para "_cat/shards?v"
        complete_url_shards = element + context_shards
        response_shards = getResponse(complete_url_shards, password)
        if response_shards:
            arreglo_shards = convertTextToArray(response_shards.text)
            # Combinar los datos de "_cat/shards?v"
            combined_array.extend(arreglo_shards)

    _, _, altagb = separar_tamanos(combined_array)
    # print(combined_array,len(combined_array))
    sendMetricsForLargeData(altagb, cluster_name)  # Enviar métricas para los registros > 55GB
    print(len(altagb))

# Ejecutar la función principal
main()

