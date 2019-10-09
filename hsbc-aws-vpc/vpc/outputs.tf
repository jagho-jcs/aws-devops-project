## Variables being exported for downstream consumption
output "vpc_tg" {
  value = "${var.vpc_tg}"
}

output "id" {
  value = "${aws_vpc.default.id}"
}

output "region" {
  value = "${var.aws_region}"
}

output "demo_env_default_tags" {
  value = "${var.demo_env_default_tags}"
}