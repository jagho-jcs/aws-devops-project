module "vpc" {
  source = "./vpc"

  aws_region                = var.aws_region
  vpc_cidr_block            = var.vpc_cidr_block
  destination_cidr_block    = var.destination_cidr_block
  igw_tg                    = var.igw_tg
  vpc_tg                    = var.vpc_tg
  ssh_admin_tg              = var.ssh_admin_tg
  dub_alb_tg                = var.dub_alb_tg
  
  demo_env_default_tags     = var.demo_env_default_tags
}

module "public-subnet" {
  source = "./public-subnet"

  aws_region                = module.vpc.region
  vpc_id                    = module.vpc.id
  destination_cidr_block    = var.destination_cidr_block
  vpc_tg                    = var.vpc_tg
  igw_tg                    = var.igw_tg
  pub_sub_1a_tg             = var.pub_sub_1a_tg
  pub_sub_1b_tg             = var.pub_sub_1b_tg
  pub_sub_1c_tg             = var.pub_sub_1c_tg
  pub_rtb_tg                = var.pub_rtb_tg  
  acls_pub_prod_tg          = var.acls_pub_prod_tg

  demo_env_default_tags     = module.vpc.demo_env_default_tags  
}

# module "security-groups" {
#   source = "./security-groups"

#   demo_env_default_tags     = module.vpc.demo_env_default_tags

#   vpc_tg                    = var.vpc_tg
#   ire_alb_tg                = var.ire_alb_tg
#   ssh_admin_tg              = var.ssh_admin_tg
#   jcswebapps_tg             = var.jcswebapps_tg
#   efs_tg                    = var.efs_tg
#   jks_tg                    = var.jks_tg
# }