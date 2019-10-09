# Define a vpc
resource "aws_vpc" "default" {
  cidr_block                = "${var.vpc_cidr_block}"
  enable_dns_hostnames      = true

  tags = "${merge(var.demo_env_default_tags, map(
    "Name", "${var.vpc_tg}",
    "Client", "JCS"
    ))}"
}