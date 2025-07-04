# ################################################################################
# # VARIABLES GLOBALES
# ################################################################################

# Código de País de despliegue.
country = "co"
# Nombre del área o equipo responsable de la aplicación/proyecto.
owner = "ti@nequi.com"
# Validación de si el componente soporta a un servicio o proceso BIA.
bia = false
# Ambiente donde será desplegado el componente. Sus únicos valores posibles serán: dev, qa, pdn, sbx, stg.
env = "pdn"
# Nombre del proyecto en el que se esta trabajando.
capacity = "ts"
# Clasificación de la confidencialidad de los datos almacenados en este recurso. Los valores permitidos son: public, internal, confidential o restricted.
confidentiality = "internal"
# Clasificación de la integridad de los datos almacenados en este recurso. Los valores permitidos son: critical, moderate, tolerable o low.
integrity = "tolerable"
# Clasificación de la disponibilidad de los datos almacenados en este recurso. Los valores permitidos son: critical, moderate, tolerable o low.
availability = "critical"
# Impacto al negocio que implica el componente especifico. 
impact = "low"
#Información relacionada a datos de tarjetas de crédito o debito de 16 dígitos sin enmascarar (PAN, CVV, fechas de expiración)
pci = false
# Dominio del negocio o la información
business_domain = null
# Visibilidad de los dominios de información que se encuentran gestionados en estos recursos. 
information_domain = "proveedores"
# Identificación de recursos que manejan datos personales.
personal_data = false
# Tags adicionales para aplicar a los recursos creados
tags = null
# Nombre de la aplicación en la que se esta trabajando.
functionality = "functionality"

################################################################################
# VARIABLES TARGET GROUP - ALB EXTERNO 
################################################################################
# Prioridad que tendrá la regla en el listener del puerto 443
rule_priority_ext = 1
# Paths al que el contendor responde
container_public_path = ["/realms/*", "/resources/*", "/robots.txt"]
# Target Group adicional
extra_target_groups_arn = "arn:aws:elasticloadbalancing:us-east-1:634614730521:targetgroup/tg-ecs-keycloak-external-sbx/7da9b65e8f2b7e71"

# #######################################
# ##     Variables ECS                 ##
# #######################################

#Puerto por el que responde el contenedor
container_port = 8080
#Puerto por el que responde el contenedor
container_additional_port = 8081
#Numero de contenedores con los que el servicio debería arrancar
desired_count = 1

#Protocolo por el que responden los contenedores (HTTP o HTTPS)
container_protocol = "HTTP"

#Protocolo
container_health_check_path = "/actuator/health"

#Segundos en que el contenedor determinará timeout en la petición
container_timeout = 30

#CPU que tendrá el contenedor de la aplicacion
container_cpu = 512

#Memoria que tendrá el contenedor de la aplicacion
container_memory = 1024

#Path por el que el contendor responde
container_path = "/api/v1/compliance/user/control-list"

# #######################################
# ##     Variables Autoscaling         ##
# #######################################

#Máximo numero de contenedores que puede escalar el servicio
container_max_capacity = 2

#Mínimo numero de contenedores que puede escalar el servicio
container_min_capacity = 1

#porcentaje de CPU para escalar hacia arriba
cpu_utilization_up = 60

#Porcentaje de memoria para escalar hacia arriba
memory_utilization_up = 70

#Porcentaje de CPU para escalar hacia abajo
cpu_utilization_down = 10

#Porcentaje de memoria para escalar hacia abajo
memory_utilization_down = 20

#Tiempo de espera para escalar hacia arriba y hacia abajo en segundos
cooldown_period = 300

# Prioridad que tendrá la regla en el listener del puerto 443
rule_priority = 3

# Objeto con las variables y secretos que tendrá el contendor
container_variables_secrets = {
  secrets = []
  environment = [{
    name  = "APPGATE_SOLTOKEN_CONNECTION_TIMEOUT"
    value = "2000"
  }]
}

# IAM policy que tendra el task role
task_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Sid": "ListYourObjects",
        "Effect": "Allow",
        "Action": "s3:ListBucket",
        "Resource": ["*"]
    }
  ]
}
EOF

# Imagen personalizada de contenedor que se usará en la definición de la tarea de ECS
container_image = null

# ¿se guardaran los logs en tipo json?
fluentbitjson = false

# ¿Se van a enviar logs a OpenSearch?
installfluentbit = false


