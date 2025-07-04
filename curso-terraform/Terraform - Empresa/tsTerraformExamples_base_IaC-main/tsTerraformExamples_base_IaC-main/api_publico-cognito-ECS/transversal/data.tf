data "aws_kms_alias" "key_ecr" {
  provider = aws.main
  name     = "alias/key-${var.capacity}-${var.country}-api-loggroup-${var.env}"
}
