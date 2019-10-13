output "vpc_name" {
  value = module.vpc.vpc_name
}

output "region" {
  value = module.vpc.region
  description = "This is the region where the VPC was deployed"
}

# output "dub_alb_tg" {
#   value = module.security-groups.dub_alb_tg
# }

# output "pub_sub_1a" {
#   value = module.public-subnet.pub_sub_1a
# }

# output "pub_sub_1b" {
#   value = module.public-subnet.pub_sub_1b
# }

# output "pub_sub_1c" {
#   value = module.public-subnet.pub_sub_1c
# }