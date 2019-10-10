output "vpc_tg" {
  value = module.vpc.vpc_tg
}

output "ire_alb_tg" {
  value = module.security-groups.ire_alb_tg
}

output "pub_sub_1a" {
  value = module.public-subnet.pub_sub_1a
}

# output "pub_sub_1b" {
#   value = module.public-subnet.pub_sub_1b
# }

# output "pub_sub_1c" {
#   value = module.public-subnet.pub_sub_1c
# }