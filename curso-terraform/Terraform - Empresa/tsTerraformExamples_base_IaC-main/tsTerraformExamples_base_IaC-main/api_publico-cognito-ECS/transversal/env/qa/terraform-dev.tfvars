################################################################################
# VARIABLES GLOBALES
################################################################################
# Nombre de la capacidad en el que se esta trabajando
capacity = "terraformExamples"
# Nombre del área o equipo responsable de la aplicación/proyecto
owner = "nequiti@nequi.com"
#El componente soporta a un servicio o proceso BIA.
bia = false
# País de despliegue
country = "co"
# Ambiente donde será desplegado el componente
env = "qa"
# Sarbanes-Oxley: Controles y medidas de seguridad de la aplicación
sox = "false"
# Clasificación de la confidencialidad de los datos almacenados en este recurso. Los valores permitidos son: public, internal, confidential o restricted.
confidentiality = "internal"
# Clasificación de la integridad de los datos almacenados en este recurso. Los valores permitidos son: critical, moderate, tolerable o low.
integrity = "low"
# Clasificación de la disponibilidad de los datos almacenados en este recurso. Los valores permitidos son: critical, moderate, tolerable o low.
availability = "low"
# Tags adicionales para aplicar a los recursos creados
tags = {}

# ###############################################################################
# # VARIABLES API-GATEWAY
# Ejemplo de creación de API Gateway privada, con integración Lambda
# este ejemplo tiene desactivada el cifrado de los logs de la API, así como
# no posee mecanismos de autenticación y autorización
# ###############################################################################

# Dominio que se asociara a los certificados y registros DNS.
# Para este caso debido a que el api es privada no poseerá dominio personalizado
# por lo que se podra dejar como un string vacio.
subdomain = ""

# Tipos de endpoint a aplicar.
# Para este ejemplo el API será privada por lo que para consumirla se deberá hacer uso
# de un VPC Endpoint, lo que implica que la variable vpce_id debera contener los Ids
# de los VPC Endpoint consumidores.
endpoint_types = "PRIVATE"

# Path del target group del balanceador.
# Para el tipo de integración Lambda no se hará uso de balanceadores por lo que esta variable no 
# se utilizará, por ello podrá enviarse como un string vacio
healtcheck_path_tg = "/"

# Descripción del api
api_description = "Api privada con integración lambda sin autenticación"

# Tipo de microservicio
# Para este caso de ejemplo se integrará con AWS Lambda
microservice_type = "LAMBDA"

# Tamaño mínimo para aplicar compresión en la respuesta de la API Gateway."
# Dependiendo de caso de uso configurar si se requiere compresión, el valor por defecto -1 
# indica que no se comprimirá
minimum_compression_size = -1

# Número de días de retención para el CloudWatch Log Group de registros de acceso por Stage
# Configurar según la necesidad, a mayor tiempo de retención mayor serán los costos.
log_retention_days = 5

# Variable para definir la configuración de los metodos del API.
method_settings = {
  "*/*" = {
    metrics_enabled        = false
    logging_level          = "ERROR"
    data_trace_enabled     = false
    throttling_burst_limit = 10
    throttling_rate_limit  = 100
  }
}

# Indica si el Log Group de cloudwatch debe estar cifrado
# Revisar si por la criticidad del proyecto es obligatorio relizar cifrado
# de los logs de Api Gateway en alguno de los ambientes.
loggroup_encryption_enabled = false

# Validación de necesidad de creación de custom domain de api gateway
# Para este ejemplo al ser una API privado no se creará custom domain.
use_custom_domain = false

# Id de los VPC Endpoint consumidores a usar en caso de que el api sea privado y se quiera límitar la politica de recurso de API Gateway.
# Tener presente que los VPC Endpoint a utilizar están centralizados en la cuenta de Networking
# por lo que se puede obtener en la documentación: https://grupobancolombia.visualstudio.com/Nequi/_wiki/wikis/Nequi.wiki/402757/VPC-Endpoint-Centralizado
vpce_id = ["vpce-0a34c39f5076ef8d9", "vpce-0b616d72a391090cf"]

################################################################################
# VARIABLES API-KEY
# Ejemplo para la creación de multiples Api Key cada uno con su plan de uso
################################################################################

# Listado de nombre de las api key a crear
# La clave de cada mapa corresponde la nombre de la Api Key que se creará en AWS
list_apikey = {
  api_key_test_1 = {
    enable_quota    = true
    quota_limit     = 100000
    quota_period    = "DAY"
    quota_offset    = 0
    enable_throttle = true
    burst_limit     = 10000
    rate_limit      = 10000
  },
  api_key_test_2 = {
    enable_quota    = true
    quota_limit     = 1000
    quota_period    = "WEEK"
    quota_offset    = 0
    enable_throttle = true
    burst_limit     = 10000
    rate_limit      = 10000
  },
  api_key_test_3 = {
    enable_quota    = false
    quota_limit     = 100000
    quota_period    = "DAY"
    quota_offset    = 0
    enable_throttle = false
    burst_limit     = 10000
    rate_limit      = 10000
  }
}
