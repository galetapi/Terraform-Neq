#pip install awswrangler https://www.youtube.com/watch?v=YpOJOVnXLW8
import requests
import json
import re
import JIRA
from datetime import datetime, timedelta
import logging
import pandas as pd
import requests
import re
import ast
import datetime
import itertools
from dateutil.relativedelta import relativedelta
class Jira:
    def __init__(self):
        self.index_data=[]
        self.password = "token"
        self.username = "jdcesped@bancolombia.com.co"
        self.url = "https://nequi.atlassian.net"
        self.jira_options = {"server": self.url}
        self.jira = JIRA(options=self.jira_options, basic_auth=(self.username, self.password))
        self.last_format=[]
    def order_date(self,date):
        day, month, year = date.split("/")
        reformulated_date = f"{year}-{month}-{day}"
        return reformulated_date
    def logs_requirement(self):
        search_criteria = 'project = CO AND issuetype = "OpenSearch - Desarchivar logs" AND status in ("Tareas por hacer", "Trabajo en curso") AND statusCategory in (2, 4)'
        dates = []
        formating_line2=[]
        list_dates = []
        final_chain = []
        type_requirement = []
        client_orders = []
        issue_key=""
        for issue in self.jira.search_issues(search_criteria, maxResults=0):
            issue_key=issue.key
            type_requirement=[str(issue.raw['fields']['customfield_11392'][i]['value']) for i in range(len(issue.raw['fields']['customfield_11392']))]  
            dates=re.findall(r'\d+/\d+/\d{4}', issue.fields.description)
#        formating_line = [[str(item).replace("/", "-") for sublist in dates for item in sublist]]  
            print(self.jira.transitions(issue, expand="transitions.fields"))
            client_orders.append({'issue_key': issue_key, 'type_requirement': type_requirement, 'dates': dates})
        return client_orders
    def comment_issue(self,issue,comment):
        comment=self.jira.add_comment(issue,comment)
        return comment
    def pending_storage_local(self):
        with open('index.csv','r') as lines:
            for line in lines:
                self.index_data.append(line)
        return self.index_data
    def change_issue_status(self,issues):
            for issue in issues:
                try: 
                    self.jira.transition_issue(issue,'81')
                except:
                    try:
                        self.jira.transition_issue(issue,'10650')
                    except:
                        try:
                            self.jira.transition_issue(issue,'2')
                        except:
                            continue
            return "estados cambiados"                    
    def pending_storage(self):
        search_criteria = 'project = CO AND issuetype = "OpenSearch - Desarchivar logs" AND status = "Pendiente de archivar"'
        dates = []
        formating_line2=[]
        list_dates = []
        final_chain = []
        type_requirement = []
        client_orders = []
        issue_key=""
        for issue in self.jira.search_issues(search_criteria, maxResults=0):
            issue_key=issue.key
            type_requirement=[str(issue.raw['fields']['customfield_11392'][i]['value']) for i in range(len(issue.raw['fields']['customfield_11392']))]  
            dates=re.findall(r'\d+/\d+/\d{4}', issue.fields.description)
#        formating_line = [[str(item).replace("/", "-") for sublist in dates for item in sublist]]    
            client_orders.append({'issue_key': issue_key, 'type_requirement': type_requirement, 'dates': dates})
        return client_orders
    
# Reformular la fecha en el formato deseado
    def sum_days(self,last_format,days):
        last_days=[]
        for day in last_format:
            future_date=datetime.datetime.strptime(day,'%Y-%m-%d')+timedelta(days=days)
            future_date=future_date.strftime('%Y-%m-%d')
            last_days.append(future_date)
        return last_days
class Opensearch:
    def __init__(self):
        self.jira=Jira()
        self.url_cold_search = "https://vpc-es-pdn-co-6-0-s3gehnpnazjvk6oxqryt2oq3xq.us-east-1.es.amazonaws.com/_cold/indices/_search"
        self.url_warm_search = "https://vpc-es-pdn-co-6-0-s3gehnpnazjvk6oxqryt2oq3xq.us-east-1.es.amazonaws.com/_cat/indices/_warm"
        self.params = {
            "scroll": "1m",  # Tiempo de retención del scroll (1 minuto en este caso)
            "size": 100       # Tamaño de la página inicial
        }
        self.url_warm= "https://vpc-es-pdn-co-6-0-s3gehnpnazjvk6oxqryt2oq3xq.us-east-1.es.amazonaws.com/_cold/migration/_warm"
        self.headers = {
              'Content-Type': 'application/json'
            }
        self.payload = {
        "timestamp_field": "@timestamp"
        }
        self.jira=Jira()

    def format_data(self,data):
        lines=data.strip().split('\n')
        data=[line.split() for line in lines]
        columns = [
            "Estado", "Tipo", "Nombre", "ID", "Prioridad", "Replicas", "Documentos", 
            "Documentos_Eliminados", "Tamaño_Total", "Tamaño_en_Uso"
        ]
        data_df = pd.DataFrame(data, columns=columns)
        indices= data_df[data_df['Nombre'].str.contains('nequilogs-(wlp|iib)')]['Nombre']
        return indices
    def search_cold_logs(self,start_time,end_time):
        url = self.url_cold_search
        body = {
            "filters": {
                "time_range": {
                    "start_time": f"{start_time}",
                    "end_time": f"{end_time}"
                }
            }
        }
        response = requests.get(url, json=body)
        response_text = response.text
        return response_text
    def search_warm_logs(self,start_time,end_time):
        url = self.url_warm_search
        body = {
            "filters": {
                "time_range": {
                    "start_time": f"{start_time}",
                    "end_time": f"{end_time}"
                }
            }
        }
        response = requests.get(url, json=body)
        response_text = response.text
        return response_text        
    def get_last_day_of_month(self,date_str):
        early_date = datetime.datetime.strptime(date_str, '%Y-%m-%d')
        try:
            final_day = early_date.replace(day=31)
        except:
            try:
                final_day = early_date.replace(day=28)
            except:
                final_day = early_date.replace(day=30)
        if final_day.month != early_date.month:
            final_day = final_day.replace(day=1, month=early_date.month + 1).replace(day=-1)
        return {'early_date':early_date.strftime('%Y-%m-%d'),'final_day':final_day.strftime('%Y-%m-%d')}
    def get_searching_indicesb(self,data):
        indices=[]
        for line in data:
                first_date=Opensearch().get_last_day_of_month(line)['early_date']
                second_date=Opensearch().get_last_day_of_month(line)['final_day']
                indices.append(Opensearch().search_cold_logs(first_date,second_date))
        return indices
    def get_buses(self,indices):
        indices=json.loads(indices)
        indices=indices['indices']
        indices_bus=[]
        start_date=[]
        end_date=[]
        for i in range(len(indices)):
            if len(re.findall(r'nequilogs-iib-ism-\d+',indices[i]['index'])) != 0:
                indices_bus.append(indices[i]['index'])
                start_date.append(datetime.datetime.strptime(str(indices[i]['start_time']),'%Y-%m-%dT%H:%M:%S.%fZ'))
                end_date.append(datetime.datetime.strptime(str(indices[i]['end_time']), '%Y-%m-%dT%H:%M:%S.%fZ'))
        buses={'index':indices_bus,'start_date':start_date,'end_date':end_date}
        return buses
    
    def search_warm_index(self):
        url = self.url_warm_search
        response = requests.get(url)
        response_text = response.text
        return response_text    
    def freeze_index(self,log_index:str):
        freeze_url = f"https://vpc-es-pdn-co-6-0-s3gehnpnazjvk6oxqryt2oq3xq.us-east-1.es.amazonaws.com/_ultrawarm/migration/{log_index}/_cold"
        response = requests.post(freeze_url, headers=self.headers, json=self.payload)
        return response.text
    def warm_index(self,log_index):
        url=self.url_warm
        body= {"indices": log_index }
        response=requests.post(url,json=body)
        return response.text
    def warm_wlp_logs(self,info_list):
        last_dates=Jira().sum_days(info_list,1)
        info_list=[datetime.datetime.strptime(day,'%Y-%m-%d').strftime('%Y-%m-%d') for day in info_list ]
        print(info_list)
        index_data=[]
        for i,j in zip(info_list,last_dates):
            indices=json.loads(Opensearch().search_cold_logs(i,j))
            try:
                indices=indices['indices']
                for i in range(len(indices)):                    
                        index_data.append(indices[i]['index'])
                        print(f"warming {indices[i]['index']}") 
                        Opensearch().warm_index(indices[i]['index'])
            except:
                continue   
        return index_data

    def warm_iib_logs(self,data:list):
        data_calculated=[datetime.datetime.strptime(day,'%Y-%m-%d') for day in data]
        indices=Opensearch().get_searching_indicesb(data)
        print(indices)
        buses_data=pd.DataFrame()
        first_filter=None
        second_filter=None
        bus_index=[]
        for index,i in zip(indices,range(len(data_calculated))):
            try:
                buses_data=pd.DataFrame(Opensearch().get_buses(index))
                first_filter=buses_data[buses_data['start_date'].ge(data_calculated[i])]
                second_filter=first_filter[first_filter['start_date'].lt(data_calculated[i]+timedelta(days=2))]
                bus_index.append(list(second_filter['index']))
                bus_index=list(itertools.chain.from_iterable(bus_index))
            except:
                break
            finally:
                for index in bus_index:
                    print(index)
                    Opensearch().warm_index(index)
                return bus_index
    def warm_indices(self,data:dict):
        dates_dataset=pd.DataFrame()
        formated_data=[]
        wlp_logs_warm=[]
        iib_logs_warm=[]
        dates_dataset=pd.DataFrame(data)    
        for element in dates_dataset['dates']:
            formated_data.append([Jira().order_date(element[i]) for i in range(len(element)) ])
        dates_dataset['dates']=formated_data
        for i in range(len(dates_dataset['type_requirement'])):
                    requirement=str(dates_dataset["type_requirement"][i])
                    actual_dates=list(dates_dataset["dates"][i])
                    if re.findall(r'nequilogs-iib-v*',requirement):         
                            iib_logs_warm.append(Opensearch().warm_iib_logs(actual_dates))
                    if re.findall(r'nequilogs-wlp-messages*',requirement):
                            print("calentando logs wlp")
                            wlp_logs_warm.append(Opensearch().warm_wlp_logs(actual_dates))
        final_data_set={'wlp_logs': wlp_logs_warm,'iib_logs':iib_logs_warm}
        for issue in dates_dataset['issue_key']:
            self.jira.comment_issue(issue,str(final_data_set))
        return final_data_set

    def obtain_cold_index(self, dates1, dates2):
        indices = []
        for i, j in zip(dates1,dates2):
            indices_dict = json.loads(Opensearch().search_cold_logs(i, j))["indices"]
            indices_sublist = [item["index"] for item in indices_dict]
            indices.append(indices_sublist)
        indices_non_empty = [item for sublist in indices if sublist for item in sublist]
        results={'indices':indices,'indices_non_empty':indices_non_empty}        
        return results
    def changing_log(self,last_format):
        log_file=[]
        for day in last_format:
            year= datetime.datetime.strptime(day,'%Y-%m-%d').year
            month=datetime.datetime.strptime(day,'%Y-%m-%d').month
            if year <= 2020:
                if month <= 3:
                    log_file.append(f"nequilogs-wlp-messages-{year}-1")
                elif month <= 6:
                    log_file.append(f"nequilogs-wlp-messages-{year}-2")
                elif month <= 9:
                    log_file.append(f"nequilogs-wlp-messages-{year}-3")
                else:
                    log_file.append(f"nequilogs-wlp-messages-{year}-4")
        return log_file
    def obtain_warm_data(self):
        warm_indices=self.search_warm_index()
        lines=warm_indices.strip().split('\n')
        warm_indices=[line.split() for line in lines]
        columns = [
        "Estado", "Tipo", "Nombre", "ID", "Prioridad", "Replicas", "Documentos", 
        "Documentos_Eliminados", "Tamaño_Total", "Tamaño_en_Uso"]
        warm_df = pd.DataFrame(warm_indices, columns=columns)
        return warm_df
    def clean_warm(self):
        warm_indices = self.search_warm_index()
        lines = warm_indices.strip().split('\n')
        warm_indices = [line.split() for line in lines]
        columns = [
            "Estado", "Tipo", "Nombre", "ID", "Prioridad", "Replicas", "Documentos", 
            "Documentos_Eliminados", "Tamaño_Total", "Tamaño_en_Uso"
        ]
        warm_df = pd.DataFrame(warm_indices, columns=columns)
        indices_to_cool = warm_df[warm_df['Nombre'].str.contains('nequilogs-(wlp|iib)')]['Nombre']
        delicate_indices = pd.read_csv('indices_intocables.csv')
        untouchable_indices = list(delicate_indices["Nombre"])
        for index in indices_to_cool:
            if index not in untouchable_indices:
                print(f"Enfriando índice {index}")
                print(self.freeze_index(index))
            else:
                print(f"indice {index} no enfriado")
                continue
        print('Índices:', untouchable_indices)
        print(self.clean_warm2())
        return "data congelada"
    def clean_warm2(self):
        warm_indices = self.search_warm_index()
        lines = warm_indices.strip().split('\n')
        warm_indices = [line.split() for line in lines]
        columns = [
            "Estado", "Tipo", "Nombre", "ID", "Prioridad", "Replicas", "Documentos", 
            "Documentos_Eliminados", "Tamaño_Total", "Tamaño_en_Uso"
        ]
        warm_df = pd.DataFrame(warm_indices, columns=columns)
        indices_to_cool = warm_df[warm_df['Nombre'].str.contains('nequilogs-(wlp|iib)')]['Nombre']
        for index in indices_to_cool:
                print(f"Enfriando índice {index}")
                print(self.freeze_index(index))
    # def clean_warm2(self):
    #     today=datetime.datetime.today()
    #     last_date=today+relativedelta(months=-3)
    #     today=datetime.datetime.strftime(today,'%Y-%m-%d')
    #     last_date=datetime.datetime.strftime(last_date,'%Y-%m-%d')
    #     logs_to_warm=json.loads(self.search_cold_logs(last_date,today))['indices']
    #     logs_warmed=[]
    #     while len(logs_to_warm)==0:
    #         logs_to_warm=json.loads(self.search_cold_logs(last_date,today))['indices']
    #         for i in range(len(logs_to_warm)):
    #             print(f"warming {logs_to_warm[i]['index']}")
    #             print(Opensearch().warm_index(logs_to_warm[i]['index']))
    #             logs_warmed.append(logs_to_warm[i]['index'])

    
    
    #     logs_warmed=pd.DataFrame({"logs":logs_warmed})
    #     logs_warmed.to_csv("logs_mes.csv")        
    def warm_old_data(self,dates_dataset):
        # Convierte las fechas en un DataFrame
        dates_df = pd.DataFrame(dates_dataset)
        old_data=[]
        old_data_inside=[]
        # Lista para almacenar las fechas antiguas
        old_dates_list = []
        issues=dates_df["issue_key"]
        # Itera sobre las fechas en el DataFrame
        for dates in dates_df['dates']:
            for date in dates:
                actual_date = datetime.datetime.strptime(date, "%d/%m/%Y")
                if actual_date.year < 2022:
                    old_dates_list.append(actual_date.strftime("%d/%m/%Y"))
        # Filtra las filas con fechas antiguas
        print(dates_df)
        old_data = dates_df[dates_df['dates'].apply(lambda x: any(re.search(date, str(x)) for date in old_dates_list))]
        print(len(old_data['dates']))
        if len(old_data) != 0:
            for dates,requirement in zip(old_data['dates'],old_data['type_requirement']):
                    for date in dates:                            
                        date=datetime.datetime.strptime(date,"%d/%m/%Y")
                    if re.findall(r'nequilogs-iib-v*',str(requirement)):
                        if date.month < 10:
                            log=f"nequilogs-iib-{date.year}-0{date.month}"
                            print(f"calentando log {log}")
                            print(Opensearch().warm_index(log))
                        else:
                            log=f"nequilogs-iib-{date.year}-{date.month}"
                            old_data.append(log)
                            print(f"calentando log {log}")
                            print(Opensearch().warm_index(log))
                    if re.findall(r'nequilogs-wlp-messages*',str(requirement)):
                        if date.month < 10:
                            log=f"nequilogs-wlp-messages-{date.year}-0{date.month}"
                            old_data.append(log)
                            print(f"calentando log {log}")
                            print(Opensearch().warm_index(log))
                        else:
                            log=f"nequilogs-wlp-messages-{date.year}-{date.month}"
                            print(f"calentando log {log}")
                            print(Opensearch().warm_index(log))           
        else:
            for date in old_dates_list:
                try:
                    date=datetime.datetime.strptime(date,"%d/%m/%Y")
                    log=f"nequilogs-iib-{date.year}-{date.month}"
                    print(f"calentando log {log}")
                    print(Opensearch().warm_index(log))
                    log=f"nequilogs-wlp-messages-{date.year}-{date.month}"
                    print(f"calentando log {log}")
                    print(Opensearch().warm_index(log)) 
                    old_data.append(log)
                except:
                    print(f"{date} no capturada")
            for issue in issues: 
                self.jira.comment_issue(issue,str(old_data))
            return old_data

# decision1=input("que logs desea usar \n 1. requerimiento de logs \n 2. pendiente almacenamiento \n")
# decision2=input("desea \n 1. calentar logs \n 2. enfriar logs \n")
# if decision1 == "1" and decision2 == "1" :
#     info_dict=Jira().logs_requirement()
#     print(info_dict)
#     for index in info_dict:
#         for i in index['dates']:
#             print(i)
#     print(Opensearch().warm_indices(info_dict))
#     print(Opensearch().warm_old_data(info_dict))
#     issues_data=pd.DataFrame(info_dict)
#     issues=issues_data["issue_key"]
#     print(issues)
# #    print(Jira().change_issue_status(issues))
# elif decision1 =="2" and decision2 == "1":
#     info_dict=Jira().pending_storage()
#     for index in info_dict:
#         for i in index['dates']:
#             print(i)
#     print(Opensearch().warm_indices(info_dict))
#     print(Opensearch().warm_old_data(info_dict))
# elif decision1 == "1" and decision2 =="2" :
#     print(Opensearch().clean_warm())
# elif decision1 == "2" and decision2 == "2":
#     print(Opensearch().clean_warm())
# else:
#     print("opcion no valida")


# for index in felipe:
#     print(index)
#     print(Opensearch().warm_index(index))
