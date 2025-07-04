################################################################################
# MODULO KMS
# Llave para cifrado repositorio de ECR
################################################################################

module "ecr_kms_mod" {
  providers = {
    aws.main = aws.main
  }

  source                  = "git@github.com:NequiTI/terraform_kms_mod.git//modules/kms?ref=v1.0.0"
  capacity                = var.capacity
  country                 = var.country
  env                     = var.env
  owner                   = var.owner
  bia                     = var.bia
  sox                     = var.sox
  confidentiality         = var.confidentiality
  integrity               = var.integrity
  availability            = var.availability
  kms_name                = var.kms_name_ecr
  usage                   = var.usage_ecr
  enable_key_rotation     = var.enable_key_rotation_ecr
  deletion_window_in_days = var.deletion_window_in_days_ecr
  kms_key_policy          = var.kms_key_policy_ecr
  tags                    = var.tags
}

################################################################################
# MODULO KMS
# Llave para cifrado de logs en API
################################################################################

module "api_logs_kms_mod" {
  providers = {
    aws.main = aws.main
  }

  source                  = "git@github.com:NequiTI/terraform_kms_mod.git//modules/kms?ref=v1.0.0"
  capacity                = var.capacity
  country                 = var.country
  env                     = var.env
  owner                   = var.owner
  bia                     = var.bia
  sox                     = var.sox
  confidentiality         = var.confidentiality
  integrity               = var.integrity
  availability            = var.availability
  kms_name                = var.kms_name
  usage                   = var.usage
  enable_key_rotation     = var.enable_key_rotation
  deletion_window_in_days = var.deletion_window_in_days
  kms_key_policy          = var.kms_key_policy
  tags                    = var.tags
}
