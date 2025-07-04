# list_data = []
cristian3172 = ["nequilogs-iib-ism-000810","nequilogs-iib-ism-000809"]

#28/12/2019
yessica3177 = ["nequilogs-wlp-messages-ism-001528", "nequilogs-wlp-messages-ism-001529", "nequilogs-wlp-messages-ism-001530",
"nequilogs-wlp-messages-ism-001531", "nequilogs-wlp-messages-ism-001628", "nequilogs-wlp-messages-ism-001629",
"nequilogs-wlp-messages-ism-001630", "nequilogs-wlp-messages-ism-001631","nequilogs-wlp-messages-ism-000756",
"nequilogs-wlp-messages-ism-000757", "nequilogs-wlp-messages-ism-000758","nequilogs-wlp-messages-ism-000908",
"nequilogs-wlp-messages-ism-000909", "nequilogs-wlp-messages-ism-000910", "nequilogs-wlp-messages-ism-000911",
"nequilogs-wlp-messages-2021-08","nequilogs-wlp-messages-ism-000015", "nequilogs-wlp-messages-ism-000016",
"nequilogs-wlp-messages-ism-000263", "nequilogs-wlp-messages-ism-000264","nequilogs-wlp-messages-2019-4"]

#19/06/2022, 25/09/2021 , 28/07/2023, 13/05/2022, 19/05/2023, 19/06/2022, 19/08/2022
yessica3178 = ["nequilogs-wlp-messages-ism-000219","nequilogs-wlp-messages-ism-000220","nequilogs-wlp-messages-ism-000875",
"nequilogs-wlp-messages-ism-000876","nequilogs-wlp-messages-ism-000877","nequilogs-wlp-messages-ism-000878",
"nequilogs-wlp-messages-ism-000182","nequilogs-wlp-messages-ism-000183","nequilogs-wlp-messages-ism-000725",
"nequilogs-wlp-messages-ism-000726","nequilogs-wlp-messages-ism-000727","nequilogs-wlp-messages-ism-000789",
"nequilogs-wlp-messages-ism-000790","nequilogs-wlp-messages-ism-000791","nequilogs-wlp-messages-ism-000280",
"nequilogs-wlp-messages-ism-000281","pa-nequilogs-wlp-messages-2021"]

#31/05/2022
yessica3179 = ["nequilogs-wlp-messages-ism-000201","nequilogs-wlp-messages-ism-000200"]

# modificar el parámetro despúés del in en la clausula for

from cold_index import Opensearch
# indices_a_archivar=[]
for index in cristian3172 :
    print(index)
    print(Opensearch().freeze_index(index))
