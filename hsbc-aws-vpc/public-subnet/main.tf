# data "aws_subnet_ids" "example" {
#   vpc_id = "${var.vpc_id}"
# }

# data "aws_subnet" "example" {
#   count = "${length(data.aws_subnet_ids.example.ids)}"
#   id    = "${data.aws_subnet_ids.example.ids[count.index]}"
# }

# output "subnet_cidr_blocks" {
#   value = ["${data.aws_subnet.example.*.cidr_block}"]
# }

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

#   ingress {    /* Rule # 110*/
#     protocol   = "tcp"
#     rule_no    = 110
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 443
#     to_port    = 443
#   }

#   ingress {    /* Rule # 111*/
#     protocol   = "tcp"
#     rule_no    = 111
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 8080
#     to_port    = 8080
#   }

#   ingress {    /* Rule # 120*/
#     protocol   = "tcp"
#     rule_no    = 120
#     action     = "allow"
#     cidr_block = "92.40.248.40/32"
#     from_port  = 22
#     to_port    = 22
#   }

#   ingress {    /* Rule # 124*/
#     protocol   = "tcp"
#     rule_no    = 124
#     action     = "allow"
#     cidr_block = "${var.priv_sub_1a}"
#     from_port  = 22
#     to_port    = 22
#   }

#   ingress {    /* Rule # 125*/
#     protocol   = "tcp"
#     rule_no    = 125
#     action     = "allow"
#     cidr_block = "${var.priv_sub_1b}"
#     from_port  = 22
#     to_port    = 22
#   }

#     ingress {    /* Rule # 126*/
#     protocol   = "tcp"
#     rule_no    = 126
#     action     = "allow"
#     cidr_block = "${var.priv_sub_1c}"
#     from_port  = 22
#     to_port    = 22
#   }

#   ingress {    /* Rule # 124*/
#     protocol   = "tcp"
#     rule_no    = 140
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 1024
#     to_port    = 65535
#   }

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