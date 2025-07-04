data "aws_vpc" "vpc_datasource" {
  provider = aws.main

  filter {
    name   = "tag:Name"
    values = ["aws-landing-zone-VPC"]
  }
}

#security group alb 
module "security_group" {
  providers = {
    aws.main = aws.main
  }

  source        = "git@github.com:NequiTI/terraform_securityGroup_Mod.git//modules/security_groups?ref=v2.0.0"
  capacity      = var.capacity
  env           = var.env
  country       = var.country
  is_glue_sg    = var.is_glue_sg
  tags          = var.tags
  vpc_id        = data.aws_vpc.vpc_datasource.id
  ingress_rules = var.ingress_rules
  functionality = var.functionality
  name          = var.name
}


module "alb" {
  providers = {
    aws.main = aws.main
  }
  source                     = "git@github.com:NequiTI/terraform_alb_Mod.git//modules/alb?ref=v1.0.1"
  capacity                   = var.capacity
  country                    = var.country
  env                        = var.env
  tags                       = var.tags
  subnets                    = var.subnets
  load_balancer_type         = var.load_balancer_type
  internal                   = var.internal
  security_groups            = var.security_groups
  idle_timeout               = var.idle_timeout
  enable_deletion_protection = var.enable_deletion_protection
  enable_http2               = var.enable_http2
  enable_waf_fail_open       = var.enable_waf_fail_open
  desync_mitigation_mode     = var.desync_mitigation_mode
  subnet_mapping             = var.subnet_mapping
  target_groups              = var.target_groups
  https_listener_rules       = var.https_listener_rules
  targets                    = var.targets
}


#security group instancias 
module "security_group" {
  providers = {
    aws.main = aws.main
  }

  source        = "git@github.com:NequiTI/terraform_securityGroup_Mod.git//modules/security_groups?ref=v2.0.0"
  capacity      = var.capacity
  env           = var.env
  country       = var.country
  is_glue_sg    = var.is_glue_sg
  tags          = var.tags
  vpc_id        = data.aws_vpc.vpc_datasource.id
  ingress_rules = var.ingress_rules
  functionality = var.functionality
  name          = var.name
}


#servidor 1
module "instance" {
  providers = {
    aws.main = aws.main
  }

  source                 = "git@github.com:NequiTI/terraform_ec2_bastion_Mod.git//modules/ec2?ref=v2.1.1"
  capacity               = var.capacity
  confidentiality        = var.confidentiality
  country                = var.country
  env                    = var.env
  integrity              = var.integrity
  schedule               = var.schedule
  tags                   = var.tags
  instance_name          = "simple"
  information_domain     = var.information_domain
  personal_data          = var.personal_data
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id   #subnet servidor 1
  vpc_security_group_ids = var.vpc_security_group_ids
  availability_zone      = var.availability_zone
  ebs_block_device       = var.ebs_block_device
  root_block_device      = var.root_block_device
  iam_role_policies      = var.iam_role_policies
} 

#servidor 2
module "instance" {
  providers = {
    aws.main = aws.main
  }

  source                 = "git@github.com:NequiTI/terraform_ec2_bastion_Mod.git//modules/ec2?ref=v2.1.1"
  capacity               = var.capacity
  confidentiality        = var.confidentiality
  country                = var.country
  env                    = var.env
  integrity              = var.integrity
  schedule               = var.schedule
  tags                   = var.tags
  instance_name          = "simple"
  information_domain     = var.information_domain
  personal_data          = var.personal_data
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id #subnet servidor 2
  vpc_security_group_ids = var.vpc_security_group_ids
  availability_zone      = var.availability_zone
  ebs_block_device       = var.ebs_block_device
  root_block_device      = var.root_block_device
  iam_role_policies      = var.iam_role_policies
} 