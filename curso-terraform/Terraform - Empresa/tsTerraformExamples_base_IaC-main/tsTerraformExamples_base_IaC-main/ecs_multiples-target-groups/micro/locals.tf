locals {
  sufix_name  = "${var.capacity}-${var.env}"
  use_lb_name = var.lb_name != null ? "-${var.lb_name}" : ""

}