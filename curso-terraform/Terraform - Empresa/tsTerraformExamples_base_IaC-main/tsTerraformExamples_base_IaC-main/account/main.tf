################################################################################
# MODULO VPC-ENDPOINT
# Ejemplo de creación de VPC Endpoint tipo Gateway para AWS S3
################################################################################

module "vpc_endpoint_s3_mod" {
  providers = {
    aws.main = aws.main
  }
  source          = "git@github.com:NequiTI/terraform_vpc_endpoints_mod.git//modules/vpc_endpoint?ref=v2.1.0"
  capacity        = var.capacity
  country         = var.country
  env             = var.env
  confidentiality = var.confidentiality
  integrity       = var.integrity
  tags            = var.tags
  route_table_ids = var.route_table_ids
  service_name    = var.service_name
  vpce_policy     = var.vpce_policy
}

################################################################################
# MODULO VPC-ASSOCIATION
# Ejemplo de creación se asociación de VPC para compartir dominos DNS 
# existentes en Amazon Route53 de la cuenta Bancolombia S.A. (Sherpa)
################################################################################

module "vpc_association_mod" {
  providers = {
    aws.main = aws.main
    aws.dns  = aws.dns
  }
  source      = "git@github.com:NequiTI/terraform_vpc_association_Mod.git//modules/vpc_association?ref=v1.1.0"
  domain_name = var.association_domain_name
  env         = var.env
}
