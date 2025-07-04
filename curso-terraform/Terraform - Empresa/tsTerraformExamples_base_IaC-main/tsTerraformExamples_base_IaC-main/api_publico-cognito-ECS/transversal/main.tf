################################################################################
# MODULO API-GATEWAY
# Ejemplo de creación de API Gateway público, con integración ECS
# este ejemplo tiene activo el cifrado de los logs de la API, así como
# Cognito como mecanismo de autenticación y autorización
################################################################################

module "public_apigateway_mod" {
  providers = {
    aws.main = aws.main
    aws.dns  = aws.dns
  }
  source = "git@github.com:NequiTI/terraform_apigateway_mod.git//modules/api-gateway?ref=v2.0.0"
  # source                      = "git@github.com:NequiTI/terraform_apigateway_mod.git//modules/api-gateway?ref=feat/2024/sp07/hu-5173086"
  capacity = var.capacity
  country  = var.country
  env      = var.env

  tags                        = var.tags
  endpoint_types              = var.endpoint_types
  api_description             = var.api_description
  use_custom_domain           = var.use_custom_domain
  healtcheck_path_tg          = var.healtcheck_path_tg
  subdomain                   = var.subdomain
  hosted_zone                 = var.api_hosted_zone
  base_path                   = var.base_path
  microservice_type           = var.microservice_type
  minimum_compression_size    = var.minimum_compression_size
  method_settings             = var.method_settings
  log_retention_days          = var.log_retention_days
  loggroup_encryption_enabled = var.loggroup_encryption_enabled
  kms_key_id                  = data.aws_kms_alias.key_ecr.arn
  vpce_id                     = var.vpce_id

}

################################################################################
# MODULO API-KEY
################################################################################

module "apikeys_mod" {
  providers = {
    aws.main = aws.main
  }
  source          = "git@github.com:NequiTI/terraform_api_resources_Mod.git//modules/api_gateway_api_keys?ref=v2.0.1"
  capacity        = var.capacity
  country         = var.country
  env             = var.env
  confidentiality = var.confidentiality
  integrity       = var.integrity
  tags            = var.tags
  list_apikey     = var.list_apikey
  api_id          = module.public_apigateway_mod.aws_api_gateway_rest_api_id

  depends_on = [module.public_apigateway_mod]
}

################################################################################
# MODULO COGNITO
################################################################################
module "cognito_mod" {
  providers = {
    aws.dns  = aws.dns
    aws.main = aws.main
  }
  source             = "git@github.com:NequiTI/terraform_authorizer_mod.git//modules/cognito?ref=v4.1.1"
  capacity           = var.capacity
  country            = var.country
  env                = var.env
  integrity          = var.integrity
  confidentiality    = var.confidentiality
  impact             = var.impact
  business_domain    = var.business_domain
  information_domain = var.information_domain
  personal_data      = var.personal_data
  tags               = var.tags
  internal_api       = var.internal_api
  schemas            = var.schemas
  string_schemas     = var.string_schemas
  number_schemas     = var.number_schemas
  resources          = var.resources
  client             = var.client
  hosted_zone        = var.cognito_hosted_zone
  authorizer_name    = var.cognito_authorizer_name

  depends_on = [module.public_apigateway_mod]
}

################################################################################
# MODULO ECS-ALB
################################################################################

module "ecs_alb_mod" {
  providers = {
    aws.main = aws.main
    aws.dns  = aws.dns
  }
  source = "git@github.com:NequiTI/terraform_ecs_alb_mod.git//modules/alb?ref=v2.2.0"
  # source                   = "git@github.com:NequiTI/terraform_ecs_alb_mod.git//modules/alb?ref=feat/2024/sp07/hu-5173086"
  capacity                 = var.capacity
  country                  = var.country
  env                      = var.env
  tags                     = var.tags
  target_group_arn         = module.public_apigateway_mod.nlb_target_group_arn
  nlb_target_group_enabled = var.nlb_target_group_enabled
  # nlb_sg_arn               = module.public_apigateway_mod.nlb_sg_arn

  depends_on = [module.public_apigateway_mod]
}
