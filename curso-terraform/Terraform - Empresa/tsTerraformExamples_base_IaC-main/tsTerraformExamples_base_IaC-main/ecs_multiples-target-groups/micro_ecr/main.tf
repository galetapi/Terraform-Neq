#################### ECR ###############################
module "ecr" {
  providers = {
    aws.main = aws.main
  }
  source         = "git@github.com:NequiTI/terraform_ecr_mod.git//modules/ecr?ref=v1.2.0"
  capacity       = var.capacity
  country        = var.country
  env            = var.env
  standard_name  = var.standard_name
  tags           = var.tags
  functionality  = var.functionality
  force_delete   = var.force_delete
  encryption_key = var.encryption_key
}
