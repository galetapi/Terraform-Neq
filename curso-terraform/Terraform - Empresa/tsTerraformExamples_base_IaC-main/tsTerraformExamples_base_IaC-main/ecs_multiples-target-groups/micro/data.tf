data "aws_vpc" "selected" {
  provider = aws.main

  filter {
    name   = "tag:Name"
    values = ["aws-landing-zone-VPC"]
  }
}
data "aws_lb" "alb" {
  provider = aws.main

  name = var.standard_name ? "alb-ecs-${var.capacity}-${var.country}${local.use_lb_name}-${var.env}" : "alb-ecs-${local.sufix_name}"
}
data "aws_lb_listener" "alb_listener" {
  provider          = aws.main
  load_balancer_arn = data.aws_lb.alb.arn
  port              = var.listener_additional_port
}