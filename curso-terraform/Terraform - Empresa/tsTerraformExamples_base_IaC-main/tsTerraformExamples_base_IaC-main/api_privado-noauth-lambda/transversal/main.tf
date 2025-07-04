################################################################################
# MODULO API-GATEWAY
# Ejemplo de creación de API Gateway privada, con integración Lambda
# este ejemplo tiene desactivada el cifrado de los logs de la API, así como
# no posee mecanismos de autenticación y autorización
################################################################################

module "apigateway_mod" {
  providers = {
    aws.main = aws.main
    aws.dns  = aws.dns
  }
  source                      = "git@github.com:NequiTI/terraform_apigateway_mod.git//modules/api-gateway?ref=v2.0.0"
  capacity                    = var.capacity
  country                     = var.country
  env                         = var.env
  tags                        = var.tags
  endpoint_types              = var.endpoint_types
  api_description             = var.api_description
  use_custom_domain           = var.use_custom_domain
  healtcheck_path_tg          = var.healtcheck_path_tg
  subdomain                   = var.subdomain
  microservice_type           = var.microservice_type
  minimum_compression_size    = var.minimum_compression_size
  method_settings             = var.method_settings
  log_retention_days          = var.log_retention_days
  loggroup_encryption_enabled = var.loggroup_encryption_enabled
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
  api_id          = module.apigateway_mod.aws_api_gateway_rest_api_id

  depends_on = [module.apigateway_mod]
}
