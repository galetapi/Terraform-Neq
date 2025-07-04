################################################################################
# VARIABLES GLOBALES
################################################################################
variable "capacity" {
  description = "Nombre de la capacidad en el que se esta trabajando."
  type        = string
  nullable    = false
}

variable "owner" {
  description = "Nombre del área o equipo responsable de la aplicación/proyecto."
  type        = string
  nullable    = false
}

variable "bia" {
  description = "El componente soporta a un servicio o proceso BIA."
  type        = bool
  nullable    = false
}

variable "country" {
  description = "País de despliegue."
  type        = string
  validation {
    condition     = contains(["co", "pa", "gt", "ts"], var.country)
    error_message = "El país seleccionado no es valido, solo esta permitido: co, pa, gt, ts."
  }
  nullable = false
}

variable "env" {
  description = "Ambiente donde será desplegado el componente. Sus únicos valores posibles serán: dev, qa, pdn, sbx, stg."
  type        = string
  validation {
    condition     = contains(["dev", "qa", "pdn", "sbx", "stg"], var.env)
    error_message = "El ambiente seleccionado no es valido, solo esta permitido: dev, qa, pdn, sbx, stg."
  }
  nullable = false
}

variable "sox" {
  description = "Sarbanes-Oxley: Controles y medidas de seguridad de la aplicación"
  type        = bool
  nullable    = false
  default     = true
}

variable "confidentiality" {
  description = "Clasificación de la confidencialidad de los datos almacenados en este recurso."
  type        = string
  validation {
    condition     = contains(["public", "internal", "confidential", "restricted"], var.confidentiality)
    error_message = "La clasificación de confidencialidad no es válida, solo esta permitida: public, internal, confidential o restricted."
  }
  nullable = false
}

variable "integrity" {
  description = "Clasificación de la integridad de los datos almacenados en este recurso."
  type        = string
  validation {
    condition     = contains(["critical", "moderate", "tolerable", "low"], var.integrity)
    error_message = "La clasificación de integridad no es válida, solo esta permitida: critical, moderate, tolerable o low."
  }
  nullable = false
}

variable "availability" {
  description = "Clasificación de la disponibilidad de los datos almacenados en este recurso."
  type        = string
  validation {
    condition     = contains(["critical", "moderate", "tolerable", "low"], var.availability)
    error_message = "La clasificación de disponibilidad no es válida, solo esta permitida: critical, moderate, tolerable o low."
  }
  nullable = false
}

variable "impact" {
  description = "Impacto al negocio que implica el componente especifico."
  type        = string
  nullable    = true
}

variable "business_domain" {
  description = "Dominio del negocio o la información."
  type        = string
  nullable    = true
}

variable "information_domain" {
  description = "Visibilidad de los dominios de información que se encuentran gestionados en estos recursos."
  type        = string
  validation {
    condition     = contains(["Accionistas", "CiberseguridadYSeguridadDeLaInformacion", "Clientes", "Comunicaciones", "Cumplimiento", "Empleados", "Financiera", "GestionDelFraude", "OperacionTecnologica", "Productos", "Proveedores", "Riesgos", "Servicios"], var.information_domain)
    error_message = "El information_domain no es válido, solo esta permitida: Accionistas, CiberseguridadYSeguridadDeLaInformacion, Clientes, Comunicaciones, Cumplimiento, Empleados,Financiera, GestionDelFraude, OperacionTecnologica,Productos, Proveedores, Riesgos, Servicios"
  }
}

variable "personal_data" {
  description = "Identificación de recursos que manejan datos personales."
  type        = bool
  nullable    = true
}

variable "pci" {
  description = "Información relacionada a datos de tarjetas de crédito o debito de 16 dígitos sin enmascarar (PAN, CVV, fechas de expiración)"
  type        = bool
  nullable    = false
}

variable "tags" {
  description = "Tags adicionales para aplicar a los recursos creados."
  type        = map(string)
  nullable    = true
}

################################################################################
# VARIABLES API-GATEWAY
################################################################################

variable "endpoint_types" {
  description = "Tipos de endpoint a aplicar."
  type        = string
  validation {
    condition     = contains(["REGIONAL", "PRIVATE", "EDGE"], var.endpoint_types)
    error_message = "Endpoint_type no soportado."
  }
  nullable = false
}

variable "api_description" {
  description = "Descripción custom del api"
  type        = string
  nullable    = false
}

variable "healtcheck_path_tg" {
  description = "path healtcheck del targetgroup del alb"
  type        = string
  nullable    = false
}

variable "subdomain" {
  description = "Dominio que se asociara a los certificados y registros DNS."
  type        = string
  nullable    = true
}

variable "api_hosted_zone" {
  description = "Nombre del dominio DNS(Existente) sobre el que se creará el subdominio para API"
  type        = string
  default     = "bancadigital.com.co"
}

variable "base_path" {
  description = "Path para el mapeo del api gateway en el custom domain (opcional)"
  type        = string
  nullable    = true
  default     = ""
}

variable "microservice_type" {
  description = "Implementación del microservicio será en contenedor ECS o Lambda"
  type        = string
  nullable    = false
  validation {
    condition     = contains(["LAMBDA", "ECS", "VPCE"], var.microservice_type)
    error_message = "Tipo de microservicio no soportado."
  }
}

variable "minimum_compression_size" {
  description = "Tamaño mínimo para aplicar compresión en la respuesta de la API Gateway."
  type        = number
  default     = -1

  validation {
    condition     = var.minimum_compression_size >= -1 && var.minimum_compression_size <= 10485760
    error_message = "El valor de minimum_compression_size debe estar en el rango de -1 a 10485760."
  }
}

variable "log_retention_days" {
  description = "Número de días de retención para el CloudWatch Log Group de registros de acceso por Stage"
  type        = number
  default     = 7
  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653], var.log_retention_days)
    error_message = "El valor de log_retention_days no es válido. Debe ser uno de los siguientes: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653."
  }
}

variable "method_settings" {
  description = <<EOF
    Variable para definir la configuración de los metodos del API.
    La key de los mapas especificados en esta variable hacen referencia a los method_path al que se aplicará la configuración, ejemplo path1/GET. El valor */* toma todos los metodos del API.
    metrics_enabled: Controla si se deben habilitar o deshabilitar las métricas para un método del stage de la API Gateway.
    logging_level:  Nivel de registro para un método. Valores permitidos OFF, ERROR y INFO.
    data_trace_enabled: Habilita o no la traza de datos para un método de la API Gateway.
    throttling_burst_limit: Límite máximo de solicitudes que se permiten en una ráfaga antes de que se aplique el límite de velocidad.
    throttling_rate_limit: Cantidad máxima de solicitudes por segundo que se permiten.
  EOF
  type = map(object({
    metrics_enabled        = bool
    logging_level          = string
    data_trace_enabled     = bool
    throttling_burst_limit = number
    throttling_rate_limit  = number
  }))
  default = {
    "*/*" = {
      metrics_enabled        = false
      logging_level          = "ERROR"
      data_trace_enabled     = false
      throttling_burst_limit = -1
      throttling_rate_limit  = -1
    }
  }
  validation {
    condition     = alltrue([for obj in values(var.method_settings) : can(index(["OFF", "ERROR", "INFO"], obj.logging_level))])
    error_message = "El nivel de registro no es valido. Los valores permitidos son: OFF, ERROR y INFO."
  }
}

variable "loggroup_encryption_enabled" {
  description = "Indica si el Log Group de cloudwatch debe estar cifrado"
  type        = bool
  nullable    = false
  default     = false
}

variable "use_custom_domain" {
  description = "Validación de necesidad de creación de custom domain de api gateway"
  type        = bool
  nullable    = false
  default     = true
}

variable "vpce_id" {
  description = "Id de los VPC Endpoint consumidores a usar en caso de que el api sea privado y se quiera límitar la politica de recurso de API Gateway"
  type        = list(string)
  nullable    = true
  default     = []
}

################################################################################
# VARIABLES API-KEY
################################################################################

variable "list_apikey" {
  description = "Lista de nombres para las API keys y su plan de uso"
  type = map(object({
    enable_quota    = bool
    quota_limit     = number
    quota_period    = string
    quota_offset    = number
    enable_throttle = bool
    burst_limit     = number
    rate_limit      = number
  }))
  validation {
    condition     = alltrue([for obj in values(var.list_apikey) : can(index(["DAY", "WEEK", "MONTH"], obj.quota_period))])
    error_message = "El periodo seleccionado no es valido. Los valores permitidos son: DAY, WEEK y MONTH."
  }
}

################################################################################
# VARIABLES COGNITO
################################################################################

variable "schemas" {
  description = "Esquemas de atributos para user pool."
  type = list(object({
    attribute_data_type      = string,
    developer_only_attribute = bool,
    mutable                  = bool,
    name                     = string,
    required                 = bool,
  }))
  default  = []
  nullable = false
}

variable "string_schemas" {
  description = "Esquemas de cadenas de atributos para user pool."
  type = list(object({
    attribute_data_type      = string,
    developer_only_attribute = bool,
    mutable                  = bool,
    name                     = string,
    required                 = bool,
    string_attribute_constraints = object({
      min_length = number
      max_length = number
    })
  }))
  default  = []
  nullable = false
}

variable "number_schemas" {
  description = "Esquemas de numero de atributos para user pool."
  type = list(object({
    attribute_data_type      = string,
    developer_only_attribute = bool,
    mutable                  = bool,
    name                     = string,
    required                 = bool,
    number_attribute_constraints = object({
      min_value = number
      max_value = number
    })
  }))
  default  = []
  nullable = false
}

variable "resources" {
  description = "Configuracion de servidores de recursos"
  type = list(object({
    identifier = string,
    name       = string,
    scopes = list(object({
      scope_name        = string,
      scope_description = string,
    }))
  }))
  default  = []
  nullable = false
}

variable "internal_api" {
  description = "Definir si la API sera INTERNAL"
  type        = bool
  nullable    = false
}

variable "client" {
  description = "Configuracion de clientes"
  type = list(object({
    name                         = string,
    generate_secret              = bool,
    supported_identity_providers = list(string),
    allowed_oauth_flows          = list(string),
    allowed_oauth_scopes         = list(string),
    explicit_auth_flows          = list(string),
    callback_urls                = list(string),
    default_redirect_uri         = string,
    logout_urls                  = list(string),
    access_token_validity        = number,
    id_token_validity            = number,
    refresh_token_validity       = number,
    token_validity_units = list(object({
      access_token  = string,
      id_token      = string,
      refresh_token = string,
    }))
  }))
  default  = []
  nullable = false
}

variable "cognito_hosted_zone" {
  description = "Nombre del dominio DNS(Existente) sobre el que se creará el subdominio para Cognito"
  type        = string
  default     = "bancadigital.com.co"
}

variable "cognito_authorizer_name" {
  description = "Valor que se agregará al nombramiento del autorizador de Cognito sobre Api Gateway"
  type        = string
  nullable    = true
  default     = null
}

################################################################################
# VARIABLES ECS-ALB
################################################################################

variable "nlb_target_group_enabled" {
  description = "Arn del target group creado en el NLB"
  type        = bool
  nullable    = false
}

