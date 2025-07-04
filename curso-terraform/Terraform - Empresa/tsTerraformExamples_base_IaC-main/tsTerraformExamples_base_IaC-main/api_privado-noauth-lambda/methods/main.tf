################################################################################
# MODULO LAMBDA
# Ejmplo de creación de Lambda con tipo de repositorio con origen ZIP
################################################################################

module "lambda_mod" {
  providers = {
    aws.main = aws.main
  }
  source        = "git@github.com:NequiTI/terraform_lambda_mod.git///modules/lambda?ref=v1.4.0"
  capacity      = var.capacity
  country       = var.country
  env           = var.env
  tags          = var.tags
  functionality = var.functionality

  environment_variables = var.environment_variables
  lambda_handler        = var.lambda_handler
  lambda_runtime        = var.lambda_runtime
  security_group_ids    = var.security_group_ids
  extra_policies        = var.extra_policies
  timeout               = var.timeout
  lambda_permissions    = var.lambda_permissions
  dynatrace_source_code = "node"
}

################################################################################
# MODULO API-RESOURCES-LAMBDA
# Ejemplo creación de recurso de API Gateway y de Metodos con integración Lambda
# Con Api Key y sin mecanismo de autenticación y autorización
################################################################################

resource "aws_api_gateway_resource" "v1" {
  # checkov:skip=CKV2_NEQUITI_1: the aws_api_gateway_method not support tags
  provider    = aws.main
  rest_api_id = data.aws_api_gateway_rest_api.capacity_rest_api.id
  parent_id   = data.aws_api_gateway_rest_api.capacity_rest_api.root_resource_id
  path_part   = "v1"
}

module "apigateway_resources_lambda_mod" {
  providers = {
    aws.main = aws.main
  }
  source        = "git@github.com:NequiTI/terraform_api_resources_Mod.git///modules/api_gateway_lambda_integration?ref=v2.0.1"
  env           = var.env
  api_resources = local.apigateway_resources_lambda
  authorizer_id = var.authorizer_id
  api_id        = data.aws_api_gateway_rest_api.capacity_rest_api.id

  depends_on = [module.lambda_mod]
}
