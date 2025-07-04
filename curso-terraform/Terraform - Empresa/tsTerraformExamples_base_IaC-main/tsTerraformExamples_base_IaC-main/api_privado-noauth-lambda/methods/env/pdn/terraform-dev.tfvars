################################################################################
# VARIABLES GLOBALES
################################################################################
# Nombre de la capacidad en el que se esta trabajando
capacity = "terraformExamples"
# Nombre del área o equipo responsable de la aplicación/proyecto
owner = "nequiti@nequi.com"
#El componente soporta a un servicio o proceso BIA.
bia = false
# País de despliegue
country = "co"
# Ambiente donde será desplegado el componente
env = "pdn"
# Sarbanes-Oxley: Controles y medidas de seguridad de la aplicación
sox = "false"
# Clasificación de la disponibilidad de los datos almacenados en este recurso. Los valores permitidos son: critical, moderate, tolerable o low.
availability = "low"
# Información relacionada a datos de tarjetas de crédito o debito de 16 dígitos sin enmascarar (PAN, CVV, fechas de expiración)
pci = false
# Impacto al negocio que implica el componente especifico. 
impact = "low"
# Tags adicionales para aplicar a los recursos creados
tags = {}
# Nombre de la aplicación en la que se esta trabajando.
functionality = "apiMethodLambda"

################################################################################
# VARIABLES LAMBDA
# Ejmplo de creación de Lambda con tipo de repositorio con origen ZIP
################################################################################

# URL SSH de repositorio para descargar codigo de lambda.
# Para este caso de ejemplo se utilizará el código base del repositorio
lambda_source = "git@github.com:NequiTI/terraform_lambda_mod.git"

# Rama de Git a clonar el repositorio para descargar codigo de lambda
lambda_source_branch = "trunk"

# Nombre del scripts de conveniencia a utilizar.
# Para este caso de ejemplo se utilizará el código base del repositorio
lambda_script = ""

# Ruta dentro del repositorio lambda_source donde se encuentra el lambda.
lambda_path = "modules/lambda/src/index.js"
# Variables de entorno en runtime de lambda.

# Variables de entorno en runtime de lambda.
environment_variables = {
  "JWT_SECRET" = "<TOKEN>"
}

# Configuracion del entrypoint para lambda.
lambda_handler = "index.py"

# Configuracion del runtime para lambda.
# Tener presente que el runtime se elige al momento de la creación del repositorio.
lambda_runtime = "python3.9"

# Nombres de subnets a utilizar.
subnets_names = ["PrivateSubnet1B", "PrivateSubnet2B"]

# Politicas adicionales a agregar al lambda.
# Son las politicas que se aplicaran al rol de la lambda, de decir, las acciones
# que podrá ejecutar la lambda en cuestión
extra_policies = [
  {
    effect = "Allow"

    actions = [
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:RegisterTargets"
    ]
    resources = ["*"]
  }
]

# Timeout para ejecucion de lambda.
timeout = 5

# Permisos hacia la funcion lambda desde otros servicios
# Es la forma de permitir que lambda sea consumida desde servicio especificos.
lambda_permissions = {
  apigateway_permissions = {
    statement_id = "AllowAPIGatewayInvoke"
    action       = "lambda:InvokeFunction"
    principal    = "apigateway.amazonaws.com"
  }
}

# IDs de security groups a utilizar.
security_group_ids = ["sg-025e893e468400df6"]

################################################################################
# VARIABLES API-RESOURCES-LAMBDA
# Ejemplo creación de recurso de API Gateway y de Metodos con integración Lambda
# Con Api Key y sin mecanismo de autenticación y autorización
################################################################################

# Id del autorizador de Cognito o Lambda Auth
# Para este ejemplo ej valor de deja en null ya que los metodos no 
# tendrán autorización ni autenticación activa
authorizer_id = null
