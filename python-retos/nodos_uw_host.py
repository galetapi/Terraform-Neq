# Recopilacion de nodos host  y ultrawarm

import requests

def convertTextToArray (entranceText):
    lista = []
    for line in entranceText.split("\n"):
        elements = line.strip().split()
        lista.append(elements)

    lista = lista [1:(len(lista)-1)]
    return lista

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

        #def main():
context = "_cat/allocation?v" #se debe cambiar o crear otra para shards?v
url_list = ["https://vpc-es-pdn-co-6-0-s3gehnpnazjvk6oxqryt2oq3xq.us-east-1.es.amazonaws.com/", "https://vpc-apt0002-os-pdn-co-01-vdql7pb6ek2ue5jzm4y6xmcr4u.us-east-1.es.amazonaws.com/"]

# Lista donde vamos a almacenar las respuestas combinadas de las dos url
combined_array = []

for element in url_list:
    cluster_name = element[8:].replace(".us-east-1.es.amazonaws.com/","")
    # print (cluster_name)
    if cluster_name == "vpc-apt0002-os-pdn-co-01-vdql7pb6ek2ue5jzm4y6xmcr4u":
        password = True
    else:
        password = False
    complete_url = element+context
    print (complete_url)
    response = getResponse(complete_url, password)
    # print(response.text)
    arreglo = convertTextToArray(response.text)
    print(f"Datos recibidos del cluster {cluster_name}: {arreglo}")
    combined_array.extend(arreglo)
    print(f"Datos combinados: {combined_array}")

def classify_data(data):
    data_20tb = [] #ultrawarn
    data_other = [] #host

    for entry in data:
        storage_value = entry[4].lower()  # columna a identar

        # Clasificar según si es exactamente 20 TB
        if "20tb" in storage_value:
            data_20tb.append(entry)
        else:
            data_other.append(entry)

    return data_20tb, data_other

data_20tb, data_other = classify_data(combined_array)


# Imprimir los resultados
print("Nodos UltraWarn (20TB):")
for entry in data_20tb:
    print(entry)

print("\nNodos Host:")
for entry in data_other:
    print(entry)

print(data_other) #contiene la lista necesaria nodos host


