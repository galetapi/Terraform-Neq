# Data utilizado para obtener el ID de Api gateway sobre el que
# se crearán los recursos y metodos.
data "aws_api_gateway_rest_api" "capacity_rest_api" {
  provider = aws.main
  name     = "api-${var.capacity}-${var.country}-dev"
}

data "aws_api_gateway_vpc_link" "capacity_vpc_link" {
  provider = aws.main
  name     = "vpclink-${var.capacity}-${var.country}-dev"
}

data "aws_kms_alias" "key_ecr" {
  provider = aws.main
  name     = "alias/key-${var.capacity}-${var.country}-ecr-${var.env}"
}

data "aws_caller_identity" "current" {
  provider = aws.main
}
