############################### ECS ####################
module "ecs" {
  providers = {
    aws.main = aws.main
  }

  source                                             = "git@github.com:NequiTI/terraform_ecs_mod.git//modules/ecs?ref=v1.1.0"
  capacity                                           = var.capacity
  country                                            = var.country
  env                                                = var.env
  tags                                               = var.tags
  functionality                                      = var.functionality
  container_port                                     = var.container_port
  desired_count                                      = var.desired_count
  container_protocol                                 = var.container_protocol
  container_health_check_path                        = var.container_health_check_path
  container_timeout                                  = var.container_timeout
  container_cpu                                      = var.container_cpu
  container_memory                                   = var.container_memory
  container_path                                     = var.container_path
  task_policy                                        = var.task_policy
  standard_name                                      = var.standard_name
  container_variables_secrets                        = var.container_variables_secrets
  installfluentbit                                   = var.installfluentbit
  fluentbitjson                                      = var.fluentbitjson
  task_start_period                                  = var.task_start_period
  container_max_capacity                             = var.container_max_capacity
  container_min_capacity                             = var.container_min_capacity
  cpu_utilization_up                                 = var.cpu_utilization_up
  memory_utilization_up                              = var.memory_utilization_up
  cpu_utilization_down                               = var.cpu_utilization_down
  memory_utilization_down                            = var.memory_utilization_down
  cooldown_period                                    = var.cooldown_period
  rule_priority                                      = var.rule_priority
  container_image                                    = var.container_image
  container_additional_port                          = var.container_additional_port
  ecs_cloudwatch_evaluation_periods_cpu_scale_in     = var.ecs_cloudwatch_evaluation_periods_cpu_scale_in
  ecs_cloudwatch_evaluation_periods_cpu_scale_out    = var.ecs_cloudwatch_evaluation_periods_cpu_scale_out
  ecs_cloudwatch_evaluation_periods_memory_scale_out = var.ecs_cloudwatch_evaluation_periods_memory_scale_out
  ecs_cloudwatch_evaluation_periods_memory_scale_in  = var.ecs_cloudwatch_evaluation_periods_memory_scale_in
  ecs_cloudwatch_evaluation_periods_sqs_usage_high   = var.ecs_cloudwatch_evaluation_periods_sqs_usage_high
  ecs_cloudwatch_evaluation_periods_sqs_usage_low    = var.ecs_cloudwatch_evaluation_periods_sqs_usage_low
  ecs_cloudwatch_period_cpu_scale_in                 = var.ecs_cloudwatch_period_cpu_scale_in
  ecs_cloudwatch_period_memory_scale_out             = var.ecs_cloudwatch_period_memory_scale_out
  ecs_cloudwatch_period_memory_scale_in              = var.ecs_cloudwatch_period_memory_scale_in
  ecs_cloudwatch_period_sqs_usage_high               = var.ecs_cloudwatch_period_sqs_usage_high
  ecs_cloudwatch_period_sqs_usage_low                = var.ecs_cloudwatch_period_sqs_usage_low
  extra_target_groups_arn                            = aws_lb_target_group.external_target_group.arn
  healthy_threshold                                  = var.healthy_threshold
  unhealthy_threshold                                = var.unhealthy_threshold
  extra_ingress_rules = [ ### Solo aplica para el adicional o segundario
    {
      from_port = 8080
      to_port   = 8080
      protocol  = "tcp"
      is_self   = true
    },
    {
      from_port = 8081
      to_port   = 8081
      protocol  = "tcp"
    }
  ]
}

################################################################################
# ALB Externo - Target group y regla de Listener 
################################################################################

resource "aws_lb_target_group" "external_target_group" {
  provider    = aws.main
  name        = "tg-ecs-${var.functionality}-ext-${var.env}"
  port        = var.container_port
  protocol    = var.container_protocol
  target_type = "ip"
  vpc_id      = data.aws_vpc.selected.id

  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = var.container_timeout + 1
    matcher             = 200
    path                = var.container_health_check_path
    protocol            = var.container_protocol
    timeout             = var.container_timeout
    unhealthy_threshold = 2
  }
  stickiness {
    type            = var.stickiness_type
    cookie_duration = var.stickiness_cookie_duration
    enabled         = var.stickiness_enabled
  }
  load_balancing_cross_zone_enabled = var.load_balancing_cross_zone_enabled_ext
  deregistration_delay              = var.deregistration_delay_ext
  protocol_version                  = var.protocol_version_ext

  lifecycle {
    ignore_changes = [
      vpc_id,
    ]
  }
}

resource "aws_lb_listener_rule" "external_listener_rule" {
  provider     = aws.main
  listener_arn = data.aws_lb_listener.alb_listener.arn
  priority     = var.rule_priority_ext

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.external_target_group.arn
  }

  dynamic "condition" {
    for_each = length(var.container_public_path) > 0 ? [true] : []
    content {
      path_pattern {
        values = var.container_public_path
      }
    }
  }
  depends_on = [
    aws_lb_target_group.external_target_group
  ]
}

