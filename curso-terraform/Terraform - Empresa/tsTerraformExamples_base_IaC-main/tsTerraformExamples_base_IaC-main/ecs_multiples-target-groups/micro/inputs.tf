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


################################################################################
# ECS Service
################################################################################

#Container variables
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


variable "container_additional_port" {
  description = "Puerto por el que responde el contenedor"
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

variable "task_policy" {
  description = "IAM policy que tendra el task role"
  type        = string
  nullable    = false
}

variable "container_variables_secrets" {
  description = "Objeto con las variables y secretos que tendrá el contendor"
  type = object({

    secretsArn = optional(list(object({
      arn = string
    })))

    secrets = optional(list(object({
      name      = string
      ValueFrom = string
    })))

    environment = optional(list(object({
      name  = string
      value = string
    })))
  })
  nullable = false
}

variable "container_image" {
  description = "Imagen personalizada de contenedor que se usará en la definición de la tarea de ECS"
  type        = string
  nullable    = true
  default     = null
}

variable "installfluentbit" {
  description = "¿Se van a enviar logs a OpenSearch?"
  type        = bool
  default     = false
}

variable "fluentbitjson" {
  description = "¿se guardaran los logs en tipo json?"
  type        = bool
  default     = false
}

variable "task_start_period" {
  description = "Período de tiempo durante el cual ECS debe esperar antes de iniciar la verificación de la salud del contenedor después de que se inicie"
  type        = number
  default     = 60
}

#Autoscaling variables
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
#Listener rule
variable "rule_priority" {
  description = "Prioridad de la regla que se creará por default (ningun micro debe tener la misma prioridad)"
  type        = number
  nullable    = false
}

variable "ecs_cloudwatch_evaluation_periods_cpu_scale_in" {
  description = "Número de períodos de evaluación para la alarma de CloudWatch"
  type        = number
  default     = 2
}

variable "ecs_cloudwatch_evaluation_periods_cpu_scale_out" {
  description = "Número de períodos de evaluación para la alarma de CloudWatch"
  type        = number
  default     = 2
}

variable "ecs_cloudwatch_evaluation_periods_memory_scale_out" {
  description = "Número de períodos de evaluación para la alarma de CloudWatch"
  type        = number
  default     = 2
}

variable "ecs_cloudwatch_evaluation_periods_memory_scale_in" {
  description = "Número de períodos de evaluación para la alarma de CloudWatch"
  type        = number
  default     = 2
}

variable "ecs_cloudwatch_evaluation_periods_sqs_usage_high" {
  description = "Número de períodos de evaluación para la alarma de CloudWatch"
  type        = number
  default     = 2
}

variable "ecs_cloudwatch_evaluation_periods_sqs_usage_low" {
  description = "Número de períodos de evaluación para la alarma de CloudWatch"
  type        = number
  default     = 2
}


variable "ecs_cloudwatch_period_cpu_scale_in" {
  description = "Periodo de tiempo para la alarma de CloudWatch"
  type        = number
  default     = 60
}

variable "ecs_cloudwatch_period_memory_scale_out" {
  description = "Periodo de tiempo para la alarma de CloudWatch"
  type        = number
  default     = 60
}

variable "ecs_cloudwatch_period_memory_scale_in" {
  description = "Periodo de tiempo para la alarma de CloudWatch"
  type        = number
  default     = 60
}

variable "ecs_cloudwatch_period_sqs_usage_high" {
  description = "Periodo de tiempo para la alarma de CloudWatch"
  type        = number
  default     = 60
}

variable "ecs_cloudwatch_period_sqs_usage_low" {
  description = "Periodo de tiempo para la alarma de CloudWatch"
  type        = number
  default     = 60
}

variable "container_public_path" {
  description = "paths al que el contendor responde"
  type        = list(string)
  default     = []
  nullable    = false
  validation {
    condition = alltrue([
      for path in var.container_public_path : can(regex("/[A-Za-z]*", path))
    ])
    error_message = "El path debe ser de tipo /[A-Za-z]"
  }
}



################################################################################
# VARIABLES TARGET GROUP - ALB EXTERNO 
################################################################################

variable "stickiness_enabled" {
  description = "Indica que la stickiness está habilitada, lo que permite que el ALB mantenga conexiones persistentes utilizando cookies"
  type        = bool
  default     = true
}

variable "stickiness_type" {
  description = "Tipo de stickiness a usar"
  type        = string
  default     = "lb_cookie"
}

variable "stickiness_cookie_duration" {
  description = "Define la duración de la cookie de stickiness en segundos"
  type        = number
  default     = 604800
}

variable "load_balancing_cross_zone_enabled_ext" {
  description = "Indica si el equilibrio de carga entre zonas está habilitado"
  type        = string
  default     = "use_load_balancer_configuration"
}

variable "deregistration_delay_ext" {
  description = "Cantidad de tiempo que debe esperar Elastic Load Balancing antes de cambiar el estado de un destino de cancelación de registro de drenaje a no utilizado. El rango es de 0 a 3600 segundos. El valor predeterminado es 300 segundos."
  type        = number
  default     = 300
}

variable "protocol_version_ext" { #TO-DO Reconfirmar con Ciber el manejo de este protocolo
  description = "Solo aplicable cuando el protocolo es HTTP o HTTPS. Especifique HTTP2 para enviar solicitudes a destinos mediante HTTP/2. El valor predeterminado es HTTP1, que envía solicitudes a objetivos utilizando HTTP/1.1."
  type        = string
  default     = "HTTP1"
}

variable "lb_name" {
  description = "nombre del lb"
  type        = string
  default     = null
}

variable "rule_priority_ext" {
  description = "Prioridad de la regla que se creará por default (ningun micro debe tener la misma prioridad)"
  type        = number
  nullable    = false
}

variable "listener_additional_port" {
  description = "Puerto adicional por donde debe escuchar el listener"
  type        = number
  nullable    = false
}

variable "healthy_threshold" {
  description = "Número de comprobaciones de estado consecutivas necesarias antes de considerar que un objetivo está en buen estado."
  type        = number
  default     = 3
}

variable "unhealthy_threshold" {
  description = "Número de errores de comprobación de estado consecutivos necesarios antes de considerar que un destino está en mal estado."
  type        = number
  default     = 2
}