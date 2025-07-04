data "aws_acm_certificate" "main" {
  provider = aws.main
  domain   = var.standard_name ? lower(coalesce(var.domain_acm, "albecs${var.capacity}${var.country}${var.env}.${var.dns_name}")) : lower(coalesce(var.domain_acm, "albecs${var.capacity}${var.env}.${var.dns_name}"))
  statuses = var.statuses
}

