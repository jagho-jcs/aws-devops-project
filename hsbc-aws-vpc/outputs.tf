output "vpc_name" {
  value = module.vpc.vpc_name
}

output "region" {
  value = module.vpc.region
  description = "This is the region where the VPC was deployed"
}