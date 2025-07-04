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
# VARIABLES API-RESOURCES
################################################################################

variable "authorizer_id" {
  description = "Id del autorizador de Cognito o Lambda Auth"
  type        = string
  nullable    = true
}

################################################################################
# VARIABLES ECR
################################################################################

variable "force_delete" {
  description = "Eliminar forzadamente el repositorio."
  type        = bool
  default     = false
  nullable    = false
}

################################################################################
# VARIABLES ECS
################################################################################

variable "container_port" {
  description = "Puerto por el que responde el contenedor"
  type        = number
  nullable    = false
}

variable "desired_count" {
  description = "Numero de contenedores con los que el servicio debería arrancar"
  type        = number
  nullable    = false
}

variable "container_protocol" {
  description = "Protocolo por el que responden los contenedores"
  type        = string
  validation {
    condition     = contains(["HTTP", "HTTPS"], var.container_protocol)
    error_message = "Solo esta permitido usar HTTP o HTTPS"
  }
  nullable = false
}

variable "container_health_check_path" {
  description = "path con el que el contendor realizará un healt check para validar que esté funcionando correctamente"
  type        = string
  validation {
    condition     = can(regex("/[A-Za-z]*", var.container_health_check_path))
    error_message = "El path debe ser de tipo /[A-Za-z]"
  }
  nullable = false
}

variable "container_timeout" {
  description = "Segundos en que el contenedor determinará timeout en la petición"
  type        = number
  nullable    = false
}

variable "container_cpu" {
  description = "CPU que tendrá el contenedor de la aplicacion"
  type        = number
  nullable    = false
  default     = 512
}

variable "container_memory" {
  description = "Memoria que tendrá el contenedor de la aplicacion"
  type        = number
  nullable    = false
  default     = 1024
}

variable "container_path" {
  description = "path al que el contendor responde"
  type        = string
  validation {
    condition     = can(regex("/[A-Za-z]*", var.container_path))
    error_message = "El path debe ser de tipo /[A-Za-z]"
  }
  nullable = false
}

variable "fluentbitjson" {
  description = "¿se guardaran los logs en tipo json?"
  type        = bool
  default     = false
}

variable "container_max_capacity" {
  description = "máximo numero de contenedores que puede escalar el servicio"
  type        = number
  nullable    = false
}

variable "container_min_capacity" {
  description = "Mínimo numero de contenedores que puede escalar el servicio"
  type        = number
  nullable    = false
}

variable "cpu_utilization_up" {
  description = "porcentaje de CPU para escalar hacia arriba"
  type        = number
  nullable    = false
  default     = 60
}

variable "memory_utilization_up" {
  description = "Porcentaje de memoria para escalar hacia arriba"
  type        = number
  nullable    = false
  default     = 70
}

variable "cpu_utilization_down" {
  description = "porcentaje de CPU para escalar hacia abajo"
  type        = number
  nullable    = false
  default     = 10
}

variable "memory_utilization_down" {
  description = "Porcentaje de memoria para escalar hacia abajo"
  type        = number
  nullable    = false
  default     = 20
}

variable "cooldown_period" {
  description = "Tiempo de espera para escalar hacia arriba y hacia abajo en segundos"
  type        = number
  nullable    = false
  default     = 30
}

variable "rule_priority" {
  description = "Prioridad de la regla que se creará por default (ningun micro debe tener la misma prioridad)"
  type        = number
  nullable    = false
}

variable "task_start_period" {
  description = "Período de tiempo durante el cual ECS debe esperar antes de iniciar la verificación de la salud del contenedor después de que se inicie"
  type        = number
  default     = 60
}
