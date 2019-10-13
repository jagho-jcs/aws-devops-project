## Expected values from the caller
variable "create_vpc" {}

variable "aws_region" {}
variable "vpc_cidr_block" {}
variable "destination_cidr_block" {}

variable "vpc_tg" {}
variable "igw_tg" {}
variable "ssh_admin_tg" {}
variable "dub_alb_tg" {}


variable "demo_env_default_tags" {}