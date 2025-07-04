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
# VARIABLES KMS ECR
# Llave para cifrado de repositorios de ecr
################################################################################

# Valor que se usará para generar el nombre de la llave KMS
kms_name_ecr = "ecr"
# Uso de la llave. ENCRYPT_DECRYPT, SIGN_VERIFY, o GENERATE_VERIFY_MAC.
usage_ecr = "ENCRYPT_DECRYPT"
# Opción de habilitar rotación automática de claves.
enable_key_rotation_ecr = true
# Período de espera, especificado en número de días antes de primitir la eliminación de una clave.
deletion_window_in_days_ecr = 7
# Política personalizada que tendrá la llave KMS
kms_key_policy_ecr = null

################################################################################
# VARIABLES KMS
# Llave para cifrado de logs en API
################################################################################

# Valor que se usará para generar el nombre de la llave KMS
kms_name = "api-loggroup"
# Uso de la llave. ENCRYPT_DECRYPT, SIGN_VERIFY, o GENERATE_VERIFY_MAC.
usage = "ENCRYPT_DECRYPT"
# Opción de habilitar rotación automática de claves.
enable_key_rotation = true
# Período de espera, especificado en número de días antes de primitir la eliminación de una clave.
deletion_window_in_days = 7
# Política personalizada que tendrá la llave KMS
kms_key_policy = <<EOF
{
    "Version": "2012-10-17",
    "Id": "key-default-1",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::634614730521:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "logs.us-east-1.amazonaws.com"
            },
            "Action": [
                "kms:Encrypt*",
                "kms:Decrypt*",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:Describe*"
            ],
            "Resource": "*",
            "Condition": {
                "ArnLike": {
                    "kms:EncryptionContext:aws:logs:arn": "arn:aws:logs:us-east-1:634614730521:*"
                }
            }
        }
    ]
}
EOF
