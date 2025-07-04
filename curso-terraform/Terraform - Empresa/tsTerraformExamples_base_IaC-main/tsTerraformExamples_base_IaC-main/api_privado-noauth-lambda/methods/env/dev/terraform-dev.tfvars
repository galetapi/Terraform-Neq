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
functionality = "apiMethodLambda"

################################################################################
# VARIABLES LAMBDA
# Ejmplo de creación de Lambda con tipo de repositorio con origen ZIP
################################################################################
# Variables de entorno en runtime de lambda.
environment_variables = {
  "JWT_SECRET" = "<TOKEN>"
}

# Configuracion del entrypoint para lambda.
lambda_handler = "index.py"

# Configuracion del runtime para lambda.
# Tener presente que el runtime se elige al momento de la creación del repositorio.
lambda_runtime = "python3.9"

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
security_group_ids = ["sg-0eed5186fac8c8479"]

################################################################################
# VARIABLES API-RESOURCES-LAMBDA
# Ejemplo creación de recurso de API Gateway y de Metodos con integración Lambda
# Con Api Key y sin mecanismo de autenticación y autorización
################################################################################

# Id del autorizador de Cognito o Lambda Auth
# Para este ejemplo ej valor de deja en null ya que los metodos no 
# tendrán autorización ni autenticación activa
authorizer_id = null
