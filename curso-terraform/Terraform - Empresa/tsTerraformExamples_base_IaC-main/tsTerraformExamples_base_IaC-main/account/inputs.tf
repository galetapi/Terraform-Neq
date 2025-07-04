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

variable "pci" {
  description = "Información relacionada a datos de tarjetas de crédito o debito de 16 dígitos sin enmascarar (PAN, CVV, fechas de expiración)"
  type        = bool
  nullable    = false
}

variable "tags" {
  description = "Tags adicionales para aplicar a los recursos creados."
  type        = map(string)
  nullable    = true
  default     = {}
}

################################################################################
# VARIABLES VPC-ENDPOINT
# Ejemplo de creación de VPC Endpoint tipo Gateway para AWS S3
################################################################################

variable "route_table_ids" {
  description = "Route tables a los que se asociará el vpc enpoint"
  type        = list(string)
  nullable    = false
  default     = []
}

variable "service_name" {
  description = "Service name del enpoint https://docs.aws.amazon.com/vpc/latest/privatelink/gateway-endpoints.html"
  type        = string
  nullable    = false
  validation {
    condition     = can(regex("com.amazonaws.+.+", var.service_name))
    error_message = "Service-name incorrecto este debe ser de tipo com.amazonaws.<region>.<service-name>"
  }
}

variable "vpce_policy" {
  description = "Política en formato JSON para adjuntar al VPC Endpoint"
  type        = string
  nullable    = true
  default     = null
}

################################################################################
# VARIABLES VPC-ASSOCIATION
# Ejemplo de creación se asociación de VPC para compartir dominos DNS 
# existentes en Amazon Route53 de la cuenta Bancolombia S.A. (Sherpa)
################################################################################

variable "association_domain_name" {
  description = "Nombre del dominio a asociar"
  type        = string
  nullable    = false
}
