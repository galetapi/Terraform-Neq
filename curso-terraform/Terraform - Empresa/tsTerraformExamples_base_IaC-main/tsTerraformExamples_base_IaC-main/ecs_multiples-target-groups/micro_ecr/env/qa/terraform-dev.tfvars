# ################################################################################
# # VARIABLES GLOBALES
# ################################################################################

# Código de País de despliegue.
country = "co"
# Nombre del área o equipo responsable de la aplicación/proyecto.
owner = "ti@nequi.com"
# Validación de si el componente soporta a un servicio o proceso BIA.
bia = false
# Ambiente donde será desplegado el componente. Sus únicos valores posibles serán: dev, qa, pdn, sbx, stg.
env = "qa"
# Nombre del proyecto en el que se esta trabajando.
capacity = "ts"
# Clasificación de la confidencialidad de los datos almacenados en este recurso. Los valores permitidos son: public, internal, confidential o restricted.
confidentiality = "internal"
# Clasificación de la integridad de los datos almacenados en este recurso. Los valores permitidos son: critical, moderate, tolerable o low.
integrity = "tolerable"
# Clasificación de la disponibilidad de los datos almacenados en este recurso. Los valores permitidos son: critical, moderate, tolerable o low.
availability = "critical"
# Impacto al negocio que implica el componente especifico. 
impact = "low"
#Información relacionada a datos de tarjetas de crédito o debito de 16 dígitos sin enmascarar (PAN, CVV, fechas de expiración)
pci = false
# Dominio del negocio o la información
# business_domain = null
# Visibilidad de los dominios de información que se encuentran gestionados en estos recursos. 
information_domain = "proveedores"
# Identificación de recursos que manejan datos personales.
personal_data = false
# Tags adicionales para aplicar a los recursos creados
tags = null
# Nombre de la aplicación en la que se esta trabajando.
functionality = "functionality"


################################################################################
# VARIABLES ESPECIFICAS
################################################################################
# Force ECR including Image ECR
force_delete = false
#ARN de la llave en KMS con la que se van a cifrar las imagenes.
encryption_key = "arn:aws:kms:us-east-1:634614730521:key/0bad79db-5715-4120-ba3c-921b070c8a66"