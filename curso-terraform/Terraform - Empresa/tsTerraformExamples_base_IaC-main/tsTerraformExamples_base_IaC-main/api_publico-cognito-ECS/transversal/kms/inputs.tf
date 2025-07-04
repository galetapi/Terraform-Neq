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
}

################################################################################
# VARIABLES KMS ECR
################################################################################

variable "kms_name_ecr" {
  description = "Valor que se usará para generar el nombre de la llave KMS"
  type        = string
  nullable    = false
}

variable "usage_ecr" {
  description = "Uso de la llave. ENCRYPT_DECRYPT, SIGN_VERIFY, o GENERATE_VERIFY_MAC."
  type        = string
  validation {
    condition     = contains(["ENCRYPT_DECRYPT", "SIGN_VERIFY", "GENERATE_VERIFY_MAC"], var.usage_ecr)
    error_message = "El uso definido no es compatible."
  }
  default = "ENCRYPT_DECRYPT"
}

variable "enable_key_rotation_ecr" {
  description = "Habilitar rotación automática de claves."
  type        = bool
  default     = true
  nullable    = false
}

variable "deletion_window_in_days_ecr" {
  description = "Período de espera, especificado en número de días antes de primitir la eliminación de una clave."
  type        = number
  nullable    = false
  default     = 30
  validation {
    condition     = var.deletion_window_in_days_ecr >= 7 && var.deletion_window_in_days_ecr <= 30
    error_message = "El valor de deletion_window_in_days_ecr debe estar en el rango entre 7 y 30 días."
  }
}

variable "kms_key_policy_ecr" {
  description = "Política personalizada que tendrá la llave KMS"
  type        = string
  nullable    = true
  default     = null
}

variable "enable_key_rotation" {
  description = "Habilitar rotación automática de claves."
  type        = bool
  default     = true
  nullable    = false
}

variable "deletion_window_in_days" {
  description = "Período de espera, especificado en número de días antes de primitir la eliminación de una clave."
  type        = number
  nullable    = false
  default     = 30
  validation {
    condition     = var.deletion_window_in_days >= 7 && var.deletion_window_in_days <= 30
    error_message = "El valor de deletion_window_in_days debe estar en el rango entre 7 y 30 días."
  }
}

################################################################################
# VARIABLES KMS
################################################################################

variable "kms_name" {
  description = "Valor que se usará para generar el nombre de la llave KMS"
  type        = string
  nullable    = false
}

variable "usage" {
  description = "Uso de la llave. ENCRYPT_DECRYPT, SIGN_VERIFY, o GENERATE_VERIFY_MAC."
  type        = string
  validation {
    condition     = contains(["ENCRYPT_DECRYPT", "SIGN_VERIFY", "GENERATE_VERIFY_MAC"], var.usage)
    error_message = "El uso definido no es compatible."
  }
  default = "ENCRYPT_DECRYPT"
}

variable "kms_key_policy" {
  description = "Política personalizada que tendrá la llave KMS"
  type        = string
  nullable    = true
  default     = null
}
