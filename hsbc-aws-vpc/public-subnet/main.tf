data "aws_availability_zones" "all" {}

resource "aws_subnet" "public" {


  count                       = "${length(data.aws_availability_zones.all.names)}"  
  
  vpc_id                      = "${var.vpc_id}"
 
  cidr_block                  = "10.10.${count.index+1}.0/24"

  availability_zone           = "${element(data.aws_availability_zones.all.names, count.index)}"

  map_public_ip_on_launch     = true

  tags = "${merge(var.demo_env_default_tags, map(
    "Name", "${var.public_tg}",
    "Environment", "${var.vpc_tg}",
    "Client", "HSBC"
    ))}"

}

resource "aws_route_table" "public_rtb" {
  vpc_id = "${var.vpc_id}"

  tags = "${merge(var.demo_env_default_tags, map(
    "Name", "${var.vpc_tg} - ${var.public_rtb_tg}",
    "Environment", "${var.vpc_tg}",
    "Client", "HSBC"
    ))}"
}

resource "aws_route_table_association" "public" {
  
  count                       = "${length(data.aws_availability_zones.all.names)}"

  subnet_id                   = "${element(aws_subnet.public.*.id, count.index)}"
  
  route_table_id              = "${aws_route_table.public_rtb.id}"

}

resource "aws_internet_gateway" "default" {
  vpc_id                      = "${var.vpc_id}"
  
  tags = "${merge(var.demo_env_default_tags, map(
    "Name", "${var.igw_tg}",
    "Environment", "${var.vpc_tg}",
    "Client", "HSBC"
    ))}"
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {

  route_table_id         = "${aws_route_table.public_rtb.id}"
  destination_cidr_block = "${var.destination_cidr_block}"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

resource "aws_network_acl" "acls_pub_prod" {
  
  vpc_id                      = "${var.vpc_id}"
  
  subnet_ids                  = aws_subnet.public.*.id 

/* This needs to be changeed to a resource type to allow for 
    future ports to be added and tested in different 
    environment!...*/
  ingress {    /* Rule # 100*/
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }  

  egress {     /* Rule 100 */
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = "${merge(var.demo_env_default_tags, map(
    "Name", "${var.acls_public_prod_tg} - ${var.vpc_tg}",
    "Environment", "${var.vpc_tg}",
    "Client", "HSBC"
    ))}"
}