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
# Clasificación de la disponibilidad de los datos almacenados en este recurso. Los valores permitidos son: critical, moderate, tolerable o low.
availability = "low"
# Información relacionada a datos de tarjetas de crédito o debito de 16 dígitos sin enmascarar (PAN, CVV, fechas de expiración)
pci = false
# Tags adicionales para aplicar a los recursos creados
tags = {}
# Nombre de la aplicación en la que se esta trabajando.
functionality = "micro-a"

################################################################################
# VARIABLES API-RESOURCES
################################################################################
# Id del autorizador de Cognito o Lambda Auth
authorizer_id = "etah03"

################################################################################
# VARIABLES ECR
################################################################################
# Force ECR including Image ECR
force_delete = true

################################################################################
# VARIABLES ECS
################################################################################
# Puerto por el que responde el contenedor
container_port = 3000
# Numero de contenedores con los que el servicio debería arrancar
desired_count = 1
# Protocolo por el que responden los contenedores (HTTP o HTTPS)
container_protocol = "HTTP"
# Path con el que el contendor realizará un health check para validar que esté funcionando correctamente
# container_health_check_path = "/actuator/health"
container_health_check_path = "/"
# Segundos en que el contenedor determinará timeout en la petición
container_timeout = 30
# CPU que tendrá el contenedor de la aplicacion
container_cpu = 512
# Memoria que tendrá el contenedor de la aplicacion
container_memory = 1024
# Path por el que el contendor responde
container_path = "/"
# ¿Se guardaran los logs del contenedor como json?
fluentbitjson = true
# Máximo numero de contenedores que puede escalar el servicio
container_max_capacity = 2
# Mínimo numero de contenedores que puede escalar el servicio
container_min_capacity = 1
# Porcentaje de CPU para escalar hacia arriba
cpu_utilization_up = 60
# Porcentaje de memoria para escalar hacia arriba
memory_utilization_up = 70
# Porcentaje de CPU para escalar hacia abajo
cpu_utilization_down = 20
# Porcentaje de memoria para escalar hacia abajo
memory_utilization_down = 20
# Tiempo de espera para escalar hacia arriba y hacia abajo en segundos
cooldown_period = 10
# Prioridad que tendrá la regla en el listener del puerto 443
rule_priority = 3
# Período de tiempo durante el cual ECS debe esperar antes de iniciar la verificación de la salud del contenedor después de que se inicie
task_start_period = 80
