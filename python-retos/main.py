import Info_Opensearch as Osearch

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

# Obtener datos de Osearch (asumiendo que hay una función para obtener texto)
entrada = Osearch.dataOPS  # Asegúrate de que esta función exista y devuelva el texto deseado
resultado = convertTextToArray(entrada) # convertir data en Array


def separar_tamanos(registros):
    tb = []
    gb = []
    kb = []
    mb = []
    nobyte = []
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
                        if valor > 50:
                            altagb.append(registro) # Almacenar registro si supera 50 GB
                    elif unidad == 'kb':
                        kb.append(valor)
                    elif unidad == 'mb':
                        mb.append(valor)
                except ValueError:
                    print(f"Valor no convertible a float: '{valor_str}' en registro {registro}")

            elif len(tamaño) >= 2 and tamaño[-1:].lower() in ['b']:
                   nobyte.append(tamaño)
                
    return tb, gb, kb, mb, nobyte, altagb

tb, gb, kb, mb, nobyte, altagb = separar_tamanos(resultado)


# Ordenar las listas de forma descendente
tb.sort(reverse=True)
gb.sort(reverse=True)
mb.sort(reverse=True)
kb.sort(reverse=True)
nobyte.sort(reverse=True)

# Ordenar registros descandente que superan 50 GB(visual)
altagb_sorted = sorted(altagb, key=lambda x: float(x[5][:-2]), reverse=True)

# Imprimir resultados
print("TB:", tb, "\tTotal:", len(tb), "\n")
print("GB:", gb, "\tTotal:", len(gb), "\n")
print("MB:", mb, "\tTotal:", len(mb), "\n")
print("KB:", kb, "\tTotal:", len(kb), "\n")
print("BasuraByte:", nobyte, "\tTotal:", len(nobyte), "\n")
# Imprimir los registros que superan 50 GB
for sublista in altagb_sorted:
    print(sublista, "\t")
print( "AltaGB son un Total:", len(altagb), "\n")






# # Imprimir el resultado de forma más visible
# for sublista in resultado:
#     print(sublista,"\t",len(sublista))  # Organiza el Array y cuenta los elementos del array


# Imprimir el resultado de forma más visible
# for sublista in resultado:
#     print(" | ".join(sublista))  # Une los elementos con " | " para mejor legibilidad


# Imprimir el resultado de datos
# print(Osearch.dataOPS)