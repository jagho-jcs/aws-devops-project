## Variables being exported for downstream consumption
output "vpc_name" {
  value = "${var.vpc_tg}"
}

# output "id" {
#   value = "${aws_vpc.default.id}"
# }

  
output "id" {
  description = "The ID of the VPC"
  value       = concat(aws_vpc.default.*.id, [""])[0]
}

output "region" {
  value = "${var.aws_region}"
}

output "dub_alb_tg" {
  value = "${var.dub_alb_tg}"
}

output "demo_env_default_tags" {
  value = "${var.demo_env_default_tags}"
}