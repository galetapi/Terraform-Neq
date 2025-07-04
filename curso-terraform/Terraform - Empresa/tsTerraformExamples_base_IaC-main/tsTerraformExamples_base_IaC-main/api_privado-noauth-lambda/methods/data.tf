# Data utilizado para obtener el ID de Api gateway sobre el que
# se crearán los recursos y metodos.
data "aws_api_gateway_rest_api" "capacity_rest_api" {
  provider = aws.main
  name     = "api-${var.capacity}-${var.country}-${var.env}"
}
