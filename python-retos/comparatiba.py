import nodos_up_50gb as upgb
# import nodos_uw_host as nohost

entrada = upgb.altagb_sorted

print(entrada)

print( "AltaGB son un Total:", len(entrada), "\n")


def elementos_comunes_y_no_comunes(lista1, lista2):
    # Extraemos el último elemento (por ejemplo, el ID) de cada sublista en lista1 y lista2
    ids_lista1 = [sublista[-1] for sublista in lista1]
    ids_lista2 = [sublista[-1] for sublista in lista2]
    
    # Elementos comunes entre las dos listas
    comunes = list(set(ids_lista1) & set(ids_lista2))
    
    # Elementos no comunes (de lista1 a lista2 y viceversa)
    no_comunes = list(set(ids_lista1) - set(ids_lista2)) + list(set(ids_lista2) - set(ids_lista1))
    
    # Devolver los elementos comunes y no comunes
    return comunes, no_comunes
    
    # # Usamos conjuntos para encontrar los elementos comunes
    # return list(set(ids_lista1) & set(ids_lista2))

# Ejemplo de uso
# lista1 = [
#     ['60', '455.3gb', '455.9gb', '1.5tb', '1.9tb', '22', 'x.x.x.x', 'x.x.x.x', '1b2bab71078aa19082c351f80c8c8100'],
#     ['60', '455.3gb', '455.9gb', '1.5tb', '1.9tb', '22', 'x.x.x.x', 'x.x.x.x', 'c79f5887ea913965ca0406baf7b4c66c'],
#     ['60', '374.7gb', '375.6gb', '1.6tb', '1.9tb', '18', 'x.x.x.x', 'x.x.x.x', '576d25f0cf573ace01075ca09627babc']
# ]

lista1 = entrada

lista2 = [
    ['nequilogs-wlp-messages-ism-001183', '1', 'p', 'STARTED', '36533677', '50.1gb', 'x.x.x.x', '576d25f0cf573ace01075ca09627babc'],
    ['nequilogs-wlp-messages-ism-001183', '1', 'p', 'STARTED', '36533677', '50.1gb', 'x.x.x.x', 'e5956650a23ba6e700c7506acfa12a32'],
    ['nequilogs-wlp-messages-ism-001153', '4', 'r', 'STARTED', '36942700', '50.1gb', 'x.x.x.x', '7204dfdd73135e5da7ef843ea0819e15']
]

# Obtener los elementos comunes y no comunes
comunes, no_comunes = elementos_comunes_y_no_comunes(lista1, lista2)

# Imprimir el resultado
print("Elementos comunes:", comunes,len(comunes))

verificar porque esta fallando y solo esta imprimiendo 35 y serian 969 registros no iguales 
ya que se equivoca en los no comunes

print("Elementos no comunes:", no_comunes,len(no_comunes))