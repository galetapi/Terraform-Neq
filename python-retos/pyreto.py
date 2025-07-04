import requests

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

def convertTextToArray (entranceText):
    lista = []
    for line in entranceText.split("\n"):
        elements = line.strip().split()
        lista.append(elements)

    lista = lista [1:(len(lista)-1)]
    return lista



def createDynatraceMessage(array, cluster_name):
    count_uwarm = 0
    count_hot = 0
    for element in array:
        shards_count = element[0]
        disk_total = element[4]
        if disk_total == "20tb":
            disk_total = disk_total.replace("tb","")
            disk_used = element[2].replace("tb","")
            disk_available = element[3].replace("tb","")
            node_type = "ultrawarm"
            count_uwarm += 1
        else:
            disk_total = disk_total.replace("gb","")
            disk_used = element[2].replace("gb","")
            disk_available = element[3].replace("gb","")
            node_type = "hot"
            count_hot += 1
        disk_used_percentage = element[5]
        node_name = element[8]
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

def sendDynatraceMetric (metric):
    url = 'https://iyl01250.live.dynatrace.com/api/v2/metrics/ingest'
    headers = {'Authorization': 'Api-Token ("token_dyna")','Content-Type':'text/plain'}
    data = metric
    resp = requests.post(url, headers=headers, data=data)
    if resp.status_code == 200 or resp.status_code == 201 or resp.status_code == 202:
        # The request was successful
        return resp
    else:
        # The request failed
        print(resp.status_code)


#def main():
context = "_cat/allocation?v" #se debe cambiar o crear otra para shards?v
url_list = ["https://vpc-es-pdn-co-6-0-s3gehnpnazjvk6oxqryt2oq3xq.us-east-1.es.amazonaws.com/", "https://vpc-apt0002-os-pdn-co-01-vdql7pb6ek2ue5jzm4y6xmcr4u.us-east-1.es.amazonaws.com/"]
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
    arreglo = convertTextToArray(response.text)
    print(arreglo)
    createDynatraceMessage(arreglo, cluster_name)


