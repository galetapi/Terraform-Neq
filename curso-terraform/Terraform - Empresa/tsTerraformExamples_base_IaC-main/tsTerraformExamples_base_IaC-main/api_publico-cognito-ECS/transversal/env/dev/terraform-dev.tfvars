################################################################################
# VARIABLES GLOBALES
################################################################################
# Nombre de la capacidad en el que se esta trabajando
capacity = "terraformexamples"
# Nombre del área o equipo responsable de la aplicación/proyecto
owner = "nequiti@nequi.com"
#El componente soporta a un servicio o proceso BIA.
bia = false
# País de despliegue
country = "co"
# Ambiente donde será desplegado el componente
env = "dev"
# Sarbanes-Oxley: Controles y medidas de seguridad de la aplicación
sox = "false"
# Clasificación de la confidencialidad de los datos almacenados en este recurso. Los valores permitidos son: public, internal, confidential o restricted.
confidentiality = "internal"
# Clasificación de la integridad de los datos almacenados en este recurso. Los valores permitidos son: critical, moderate, tolerable o low.
integrity = "low"
# Clasificación de la disponibilidad de los datos almacenados en este recurso. Los valores permitidos son: critical, moderate, tolerable o low.
availability = "low"
# Impacto al negocio que implica el componente especifico. 
impact = "low"
# Dominio del negocio o la información
business_domain = null
# Visibilidad de los dominios de información que se encuentran gestionados en estos recursos. 
information_domain = "Financiera"
# Identificación de recursos que manejan datos personales.
personal_data = false
# Información relacionada a datos de tarjetas de crédito o debito de 16 dígitos sin enmascarar (PAN, CVV, fechas de expiración)
pci = false
# Tags adicionales para aplicar a los recursos creados
tags = {}

################################################################################
# MODULO API-GATEWAY
# Ejemplo de creación de API Gateway público, con integración ECS
# este ejemplo tiene activo el cifrado de los logs de la API, así como
# Cognito como mecanismo de autenticación y autorización
################################################################################

# Dominio que se asociara a los certificados y registros DNS.
# Para este caso se usará un dominio personalizado de ejemplo
subdomain = "terraformexamples"

# Tipos de endpoint a aplicar.
# Para este ejemplo el API será pública por lo que para consumirla no será necesario el uso
# de un VPC Endpoint, lo que implica que la variable vpce_id podrá estar vacio
endpoint_types = "REGIONAL"

# Path del target group del balanceador.
# Para el tipo de integración ECS se hace uso de balanceadores por lo que esta variable 
# contendrá el valor por el que el micro servicio reporta su estado
healtcheck_path_tg = "/"

# Descripción del api
api_description = "Api pública con integración ECS y autenticación y autorización Cognito"

# Tipo de microservicio
# Para este caso de ejemplo se integrará con AWS ECS
microservice_type = "ECS"

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
loggroup_encryption_enabled = true

# Validación de necesidad de creación de custom domain de api gateway
# Para este ejemplo al ser una API pública se recomienda la creación de custom domain.
use_custom_domain = true

# Nombre del dominio DNS(Existente) sobre el que se creará el subdominio para API
api_hosted_zone = "bancadigital.com.co"

# Path para el mapeo del api gateway en el custom domain (opcional)
base_path = "test"

# Id de los VPC Endpoint consumidores a usar en caso de que el api sea privado y se quiera límitar la politica de recurso de API Gateway.
# Para este caso como el API será pública no es necesario definir VPC Endpoint
vpce_id = []


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
  }
}

################################################################################
# VARIABLES COGNITO
################################################################################

# Definir si la API sera INTERNAL.
internal_api = false
# Configuracion de clientes.
client = [
  {
    name                         = "terraformexamples_test"
    generate_secret              = true
    supported_identity_providers = ["COGNITO"]
    allowed_oauth_flows          = ["client_credentials"]
    allowed_oauth_scopes         = ["test/uno"]
    explicit_auth_flows          = ["ADMIN_NO_SRP_AUTH"]
    callback_urls                = ["https://www.nequi.com.co/test-nequi"]
    default_redirect_uri         = "https://www.nequi.com.co/test-nequi"
    logout_urls                  = ["https://www.nequi.com.co/test-nequi"]
    access_token_validity        = 1
    id_token_validity            = 1
    refresh_token_validity       = 2
    token_validity_units = [{
      access_token  = "days",
      id_token      = "days",
      refresh_token = "days",
    }]
  }
]
# Esquemas de atributos para user pool.
schemas = [{
  attribute_data_type      = "String" # Usamos "String" en mayúscula para seguir la convención de Amazon Cognito.
  developer_only_attribute = false
  mutable                  = false
  name                     = "app"
  required                 = false
}]
# Esquemas de cadenas de atributos para user pool.
string_schemas = [{
  attribute_data_type      = "String" # Usamos "String" en mayúscula para seguir la convención de Amazon Cognito.
  developer_only_attribute = false
  mutable                  = false
  name                     = "ria"
  required                 = false
  string_attribute_constraints = {
    min_length = 1
    max_length = 10
  }
}]
# Esquemas de numero de atributos para user pool.
number_schemas = [{
  attribute_data_type      = "Number" # Usamos "Number" en mayúscula para seguir la convención de Amazon Cognito.
  developer_only_attribute = false
  mutable                  = false
  name                     = "terrapay"
  required                 = false
  number_attribute_constraints = {
    min_value = 1
    max_value = 10
  }
}]
# Configuracion de servidores de recursos
resources = [{
  identifier = "test",
  name       = "test",
  scopes = [{
    scope_name        = "uno",
    scope_description = "uno",
  }]
}]
# Nombre del dominio DNS(Existente) sobre el que se creará el subdominio para Cognito
cognito_hosted_zone = "bancadigital.com.co"
# Valor que se agregará al nombramiento del autorizador de Cognito sobre Api Gateway
cognito_authorizer_name = "auth-terraform-examples"

################################################################################
# VARIABLES ECS-ALB
################################################################################
# Arn del target group creado en el NLB
nlb_target_group_enabled = true
