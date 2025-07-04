# ################################################################################
# # VARIABLES GLOBALES
# ################################################################################
variable "country" {
  description = "País de despliegue."
  type        = string
  validation {
    condition     = contains(["co", "pa", "gt", "ts"], var.country)
    error_message = "El país seleccionado no es valido, solo esta permitido: co, pa, gt y ts."
  }
  nullable = false
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

variable "pci" {
  description = "Información relacionada a datos de tarjetas de crédito o debito de 16 dígitos sin enmascarar (PAN, CVV, fechas de expiración)"
  type        = bool
  nullable    = false
  default     = true
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

variable "standard_name" {
  description = "Variable que define si se usa el estándar de nombramiento de Nequi, si es true activa el nombramiento de recursos actualizados lo cual puede generar una reconstrucción sobre los recursos existentes creados con el estándar antiguo. Utilizar false para usar el estándar de nombres antiguo."
  type        = bool
  default     = false
  nullable    = false
}
variable "sox" {
  description = "Sarbanes-Oxley: Controles y medidas de seguridad de la aplicación"
  type        = bool
  nullable    = false
  default     = true
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

variable "capacity" {
  description = "Nombre del proyecto en el que se esta trabajando. Su valor debe estar en minúscula."
  type        = string
  nullable    = false
  validation {
    condition     = lower(var.capacity) == var.capacity
    error_message = "Valor de capacity no válido, solo está permitido en minúscula."
  }
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

################################################################################
# VARIABLES ESPECIFICAS
################################################################################

variable "force_delete" {
  description = "Eliminar forzadamente el repositorio."
  type        = bool
  default     = false
  nullable    = false
}

variable "encryption_key" {
  description = "ARN de la llave en KMS con la que se van a cifrar las imagenes."
  type        = string
  nullable    = false
}