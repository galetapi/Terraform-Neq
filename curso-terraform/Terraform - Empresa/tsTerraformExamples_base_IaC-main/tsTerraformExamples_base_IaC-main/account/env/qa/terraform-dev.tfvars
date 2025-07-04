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
env = "qa"
# Sarbanes-Oxley: Controles y medidas de seguridad de la aplicación
sox = "false"
# Clasificación de la confidencialidad de los datos almacenados en este recurso. Los valores permitidos son: public, internal, confidential o restricted.
confidentiality = "internal"
# Clasificación de la integridad de los datos almacenados en este recurso. Los valores permitidos son: critical, moderate, tolerable o low.
integrity = "low"
# Clasificación de la disponibilidad de los datos almacenados en este recurso. Los valores permitidos son: critical, moderate, tolerable o low.
availability = "low"
# Información relacionada a datos de tarjetas de crédito o debito de 16 dígitos sin enmascarar (PAN, CVV, fechas de expiración)
pci = false
# Tags adicionales para aplicar a los recursos creados
tags = {}

################################################################################
# VARIABLES VPC-ENDPOINT
# Ejemplo de creación de VPC Endpoint tipo Gateway para AWS S3
################################################################################

# Route tables a los que se asociará el vpc enpoint
# Sobre las tablas de enrutamiento que se definan en esta lista se crearán
# rutas estáticas para que las peticiones en este caso a S3 transiten por 
# la red interna de AWS
route_table_ids = ["rtb-0771225c0e61dc6c7"]

# Service name del enpoint "https://docs.aws.amazon.com/vpc/latest/privatelink/gateway-endpoints.html
# Importante tener presente que para el tipo de VPC Endpoint gateway solo es permitido
# service name de AWS DynamoDB o como es este caso AWS S3
service_name = "com.amazonaws.us-east-1.s3"

# Política en formato JSON para adjuntar al VPC Endpoint
# Está política se asocia al VPC Endpoint y limita las acciones que se
# puedes realizar, para este caso de ejemplo se permite listar, visualizar y cargar archivos
vpce_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Allow-access-to-specific-bucket",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
         "s3:ListBucket",
         "s3:GetObject",
         "s3:PutObject"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF

################################################################################
# VARIABLES VPC-ASSOCIATION
# Ejemplo de creación se asociación de VPC para compartir dominos DNS 
# existentes en Amazon Route53 de la cuenta Bancolombia S.A. (Sherpa)
################################################################################

# Nombre del dominio a asociar
# Para este caso especifico de asociará a VPC de la cuenta de despligue el 
# domino privado nequi.internal existente en la cuenta Sherpa para que se pueda 
# hacer uso de él desde la cuenta de despliegue. Importante tener presente que
# solo se asocian dominios privados.
association_domain_name = "nequi.internal"
