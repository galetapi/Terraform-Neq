#---------------------------CLUSTER DE ECS FARGATE-----------------#
module "ecs_cluster" {
  providers = {
    aws.dns  = aws.dns
    aws.main = aws.main
  }
  source                   = "git@github.com:NequiTI/terraform_ecs_alb_mod.git//modules/alb?ref=v2.1.0"
  capacity                 = var.capacity
  country                  = var.country
  env                      = var.env
  business_domain          = var.business_domain
  standard_name            = var.standard_name
  tags                     = var.tags
  use_capacity_providers   = var.use_capacity_providers
  use_fargate_spot         = var.use_fargate_spot
  base_fargate             = var.base_fargate
  weight_fargate           = var.weight_fargate
  weight_fargate_spot      = var.weight_fargate_spot
  nlb_target_group_enabled = false

}

################################################################################
# Listener 
################################################################################

resource "aws_lb_listener" "listener" {
  provider = aws.main

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Invalid path"
      status_code  = "404"
    }
  }

  load_balancer_arn = module.ecs_cluster.alb_arn
  certificate_arn   = data.aws_acm_certificate.main.arn
  port              = var.listener_additional_port
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
}