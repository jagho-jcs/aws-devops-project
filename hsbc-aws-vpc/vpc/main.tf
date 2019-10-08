# Define a vpc
resource "aws_vpc" "default_vpc" {
  cidr_block = "${var.vpc_cidr_block}"


  tags = "${merge(var.demo_env_default_tags, map(
    "Name", "${var.vpc_tg}",
    "Client", "JCS"
    ))}"
}

resource "aws_internet_gateway" "prod_igw" {
  vpc_id = "${aws_vpc.default_vpc.id}"
  
  tags = "${merge(var.demo_env_default_tags, map(
    "Name", "${var.igw_tg}",
    "Environment", "${var.vpc_tg}",
    "Client", "JCS"
    ))}"
}