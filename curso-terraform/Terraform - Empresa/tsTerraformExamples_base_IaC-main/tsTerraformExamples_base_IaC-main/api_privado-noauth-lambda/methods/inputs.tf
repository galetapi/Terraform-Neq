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

variable "availability" {
  description = "Clasificación de la disponibilidad de los datos almacenados en este recurso."
  type        = string
  validation {
    condition     = contains(["critical", "moderate", "tolerable", "low"], var.availability)
    error_message = "La clasificación de disponibilidad no es válida, solo esta permitida: critico, moderado, tolerable o bajo."
  }
  nullable = false
}

variable "sox" {
  description = "Sarbanes-Oxley: Controles y medidas de seguridad de la aplicación"
  type        = bool
  nullable    = false
  default     = true
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

variable "functionality" {
  description = "Nombre de la aplicación en la que se esta trabajando."
  type        = string
  nullable    = false
}
################################################################################
# VARIABLES LAMBDA
# Ejmplo de creación de Lambda con tipo de repositorio con origen ZIP
################################################################################

variable "environment_variables" {
  description = "Variables de entorno en runtime de lambda."
  type        = map(string)
  nullable    = true
  default     = null
}

variable "lambda_handler" {
  description = "Configuracion del entrypoint para lambda."
  type        = string
  nullable    = true
  default     = null
}

variable "lambda_runtime" {
  description = "Configuracion del runtime para lambda."
  type        = string
  validation {
    condition     = contains(["nodejs18.x", "nodejs16.x", "nodejs14.x", "nodejs12.x", "python3.9", "python3.8", "python3.7", "java11", "java8.al2", "java8", "dotnetcore3.1", "dotnet6", "dotnet5.0", "go1.x"], var.lambda_runtime)
    error_message = "El runtime seleccionado no es valido: https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html"
  }
  nullable = false
}

variable "security_group_ids" {
  description = "IDs de security groups a utilizar."
  type        = list(string)
  nullable    = false
}

variable "extra_policies" {
  description = "Politicas adicionales a agregar al lambda."
  type = list(object({
    effect    = string
    actions   = list(string)
    resources = list(string)
  }))
  default = []
}

variable "timeout" {
  description = "Timeout para ejecucion de lambda."
  type        = number
  default     = 15
}

variable "lambda_permissions" {
  description = "Permisos hacia la funcion lambda desde otros servicios"
  type = map(object({
    statement_id = string
    action       = string
    principal    = string
  }))
}

################################################################################
# VARIABLES API-RESOURCES-LAMBDA
# Ejemplo creación de recurso de API Gateway y de Metodos con integración Lambda
# Con Api Key y sin mecanismo de autenticación y autorización
################################################################################

variable "authorizer_id" {
  description = "Id del autorizador de Cognito o Lambda Auth"
  type        = string
  nullable    = true
}
