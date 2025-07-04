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
env = "dev"
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
business_domain = null
# Visibilidad de los dominios de información que se encuentran gestionados en estos recursos. 
information_domain = "proveedores"
# Identificación de recursos que manejan datos personales.
personal_data = false
# Tags adicionales para aplicar a los recursos creados
tags = null
# Nombre de la aplicación en la que se esta trabajando.
functionality = "functionality"
standard_name = false

###############################################################################
#VARIABLES ESPECIFICAS
###############################################################################

# Nombre del subdominio personalizado, si no se ingresa un valor se va a crear el nombre segun los lineaminetos establecidos
custom_domain = "bancatest"

## ingresar puerto adicional asociar en el contenedor.
listener_additional_port = 4048

#Target group del NLB para asociar el ALB
target_group_arn = ""

#Determina si se está usando un NLB en la infraestructura
nlb_target_group_enabled = false

# Nombre del dominio DNS(Existente) sobre el que se creará el subdominio para el módulo
hosted_zone = "bancadigital.com.co"

# Regla de ingress para el security group
sg_custom_ingress = [{
  description = "Acceso desde AppGate"
  from_port   = 443
  to_port     = 443
  ip_protocol = "TCP"
  cidr_ipv4   = "192.168.254.235/32"
}]

################################################################################
# VARIABLES ECS
################################################################################
# El número mínimo de tareas que deben ejecutarse en el proveedor de capacidad especificado antes de que se distribuyan las tareas a otros proveedores.
base_fargate = 2
# La prioridad del proveedor de capacidad. Una mayor ponderación significa una mayor preferencia.
weight_fargate = 2
# La prioridad del proveedor de capacidad. Una mayor ponderación significa una mayor preferencia.
weight_fargate_spot = 2
#Indica si va utilizar un Capacitu Providers
use_capacity_providers = false
#Indica si se debe incluir FARGATE_SPOT como proveedor de capacidad
use_fargate_spot = false