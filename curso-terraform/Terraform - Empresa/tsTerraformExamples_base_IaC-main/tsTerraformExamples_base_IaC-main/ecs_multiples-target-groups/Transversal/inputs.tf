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


variable "env" {
  description = "Ambiente donde será desplegado el componente. Sus únicos valores posibles serán: dev, qa, pdn, sbx, stg."
  type        = string
  validation {
    condition     = contains(["dev", "qa", "pdn", "sbx", "stg"], var.env)
    error_message = "El ambiente seleccionado no es valido, solo esta permitido: dev, qa, pdn, sbx, stg."
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


variable "standard_name" {
  description = "Variable que define si se usa el estándar de nombramiento de Nequi, si es true activa el nombramiento de recursos actualizados lo cual puede generar una reconstrucción sobre los recursos existentes creados con el estándar antiguo. Utilizar false para usar el estándar de nombres antiguo."
  type        = bool
  default     = false
  nullable    = false
}

variable "business_domain" {
  description = "Dominio del negocio o la información."
  type        = string
  nullable    = true
}

################################################################################
# VARIABLES CLUSTER ECS                                                        
################################################################################
variable "base_fargate" {
  description = "El número mínimo de tareas que deben ejecutarse en el proveedor de capacidad especificado antes de que se distribuyan las tareas a otros proveedores."
  type        = number
  default     = 2
}

variable "weight_fargate" {
  description = "La prioridad del proveedor de capacidad. Una mayor ponderación significa una mayor preferencia."
  type        = number
  default     = 0
}


variable "weight_fargate_spot" {
  description = "La prioridad del proveedor de capacidad. Una mayor ponderación significa una mayor preferencia."
  type        = number
  default     = 2
}

variable "use_capacity_providers" {
  description = "Indica si se debe incluir FARGATE_SPOT como proveedor de capacidad."
  type        = bool
  default     = false
}

variable "use_fargate_spot" {
  description = "Indica si se debe incluir FARGATE_SPOT como proveedor de capacidad."
  type        = bool
  default     = false
}


variable "listener_additional_port" {
  description = "Puerto por el que responde el contenedor"
  type        = number
  nullable    = false
}

variable "domain_acm" {
  description = "La prioridad del proveedor de capacidad. Una mayor ponderación significa una mayor preferencia."
  type        = string
  default     = "albecstsdev.bancadigital.com.co"

}

variable "statuses" {
  description = "La prioridad del proveedor de capacidad. Una mayor ponderación significa una mayor preferencia."
  type        = string
  default     = ["ISSUED"]

}

variable "dns_name" {
  description = "La prioridad del proveedor de capacidad. Una mayor ponderación significa una mayor preferencia."
  type        = string
  default     = "bancadigital.com.co"

}