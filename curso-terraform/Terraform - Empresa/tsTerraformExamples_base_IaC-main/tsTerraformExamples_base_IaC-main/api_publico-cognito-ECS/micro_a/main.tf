################################################################################
# MODULO API-RESOURCES-LAMBDA
# Ejemplo creación de recurso de API Gateway y de Metodos con integración ECS
# Con Api Key y mecanismo de autenticación y autorización Cognito
################################################################################

resource "aws_api_gateway_resource" "v1" {
  # checkov:skip=CKV2_NEQUITI_1: the aws_api_gateway_method not support tags
  provider    = aws.main
  rest_api_id = data.aws_api_gateway_rest_api.capacity_rest_api.id
  parent_id   = data.aws_api_gateway_rest_api.capacity_rest_api.root_resource_id
  path_part   = "v1"
}

module "apigateway_resources_mod" {
  providers = {
    aws.main = aws.main
  }
  source        = "git@github.com:NequiTI/terraform_api_resources_Mod.git///modules/api_gateway_resources_vpclink?ref=v2.0.1"
  env           = var.env
  api_resources = local.apigateway_resources_vpclink
  authorizer_id = var.authorizer_id
  vpc_link_id   = data.aws_api_gateway_vpc_link.capacity_vpc_link.id
  api_id        = data.aws_api_gateway_rest_api.capacity_rest_api.id
}

################################################################################
# MODULO ECR
################################################################################

module "module_ecr" {
  providers = {
    aws.main = aws.main
  }

  source         = "git@github.com:NequiTI/terraform_ecr_mod.git//modules/ecr?ref=v1.2.0"
  capacity       = var.capacity
  country        = var.country
  env            = var.env
  tags           = var.tags
  functionality  = var.functionality
  force_delete   = var.force_delete
  encryption_key = data.aws_kms_alias.key_ecr.arn
}

################################################################################
# MODULO ECS
################################################################################

module "module_ecs" {
  providers = {
    aws.main = aws.main
  }

  source                      = "git@github.com:NequiTI/terraform_ecs_mod.git//modules/ecs?ref=v1.1.0"
  capacity                    = var.capacity
  country                     = var.country
  env                         = var.env
  tags                        = var.tags
  functionality               = var.functionality
  container_port              = var.container_port
  desired_count               = var.desired_count
  container_protocol          = var.container_protocol
  container_health_check_path = var.container_health_check_path
  container_timeout           = var.container_timeout
  container_cpu               = var.container_cpu
  container_memory            = var.container_memory
  container_path              = var.container_path
  task_policy                 = local.task_policy
  container_variables_secrets = local.container_variables_secrets
  fluentbitjson               = var.fluentbitjson
  container_max_capacity      = var.container_max_capacity
  container_min_capacity      = var.container_min_capacity
  cpu_utilization_up          = var.cpu_utilization_up
  memory_utilization_up       = var.memory_utilization_up
  cpu_utilization_down        = var.cpu_utilization_down
  memory_utilization_down     = var.memory_utilization_down
  cooldown_period             = var.cooldown_period
  rule_priority               = var.rule_priority
  task_start_period           = var.task_start_period
}


