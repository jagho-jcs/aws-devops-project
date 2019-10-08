data "aws_availability_zones" "all" {}

resource "aws_subnet" "pub_sub_1a" {

  count                       = "${length(data.aws_availability_zones.all.names)}"  
  vpc_id                      = "${var.vpc_id}"
 
  cidr_block                  = "10.10.${count.index+1}.0/24"

  availability_zone           = "${element(data.aws_availability_zones.all.names, count.index)}"

  map_public_ip_on_launch     = true

  tags = "${merge(var.demo_env_default_tags, map(
    "Name", "${var.pub_sub_1a_tg}",
    "Environment", "${var.vpc_tg}",
    "Client", "HSBC"
    ))}"

}

resource "aws_subnet" "pub_sub_1b" {

  count                       = "${length(data.aws_availability_zones.all.names)}"
  vpc_id                      = "${var.vpc_id}"

  cidr_block                  = "10.10.${count.index+21}.0/24"
  
  availability_zone           = "${element(data.aws_availability_zones.all.names, count.index)}"

  map_public_ip_on_launch     = true
  
  tags = "${merge(var.demo_env_default_tags, map(
    "Name", "${var.pub_sub_1b_tg}",
    "Environment", "${var.vpc_tg}",
    "Client", "HSBC"
    ))}"
}

resource "aws_subnet" "pub_sub_1c" {

  count                       = "${length(data.aws_availability_zones.all.names)}"
  vpc_id                      = "${var.vpc_id}"
  
  cidr_block                  = "10.10.${count.index+31}.0/24"

  availability_zone           = "${element(data.aws_availability_zones.all.names, count.index)}"

  map_public_ip_on_launch     = true
  
  tags = "${merge(var.demo_env_default_tags, map(
    "Name", "${var.pub_sub_1c_tg}",
    "Environment", "${var.vpc_tg}",
    "Client", "HSBC"
    ))}"
}

resource "aws_route_table" "pub_rtb" {
  vpc_id = "${var.vpc_id}"

  tags = "${merge(var.demo_env_default_tags, map(
    "Name", "${var.vpc_tg} - ${var.pub_rtb_tg}",
    "Environment", "${var.vpc_tg}",
    "Client", "HSBC"
    ))}"
}

resource "aws_route_table_association" "pub_sub_1a" {
  
  count                       = "${length(data.aws_availability_zones.all.names)}"

  subnet_id                   = "${element(aws_subnet.pub_sub_1a.*.id, count.index)}"
  route_table_id              = "${aws_route_table.pub_rtb.id}"

}

resource "aws_route_table_association" "pub_sub_1b" {
  
  count                       = "${length(aws_subnet.pub_sub_1b)}"

  subnet_id                   = "${element(aws_subnet.pub_sub_1b.*.id, count.index)}"
  route_table_id              = "${aws_route_table.pub_rtb.id}"
}

resource "aws_route_table_association" "pub_sub_1c" {
  
  count                       = "${length(aws_subnet.pub_sub_1c)}"

  subnet_id                   = "${element(aws_subnet.pub_sub_1c.*.id, count.index)}"
  route_table_id              = "${aws_route_table.pub_rtb.id}"
}

resource "aws_network_acl" "acls_pub_prod" {
  
  vpc_id                      = "${var.vpc_id}"
  subnet_ids                  = "${flatten(
                                    [
                                      aws_subnet.pub_sub_1a.*.id, 
                                      aws_subnet.pub_sub_1b.*.id,
                                      aws_subnet.pub_sub_1c.*.id
                                  ]
                                )
                              }"
/* This needs to be changeed to a resource type to allow for 
    future ports to be added and tested in different 
    environment!...*/
  ingress {    /* Rule # 100*/
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }  

  ingress {    /* Rule # 110*/
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  ingress {    /* Rule # 111*/
    protocol   = "tcp"
    rule_no    = 111
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 8080
    to_port    = 8080
  }

  ingress {    /* Rule # 120*/
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "92.40.248.40/32"
    from_port  = 22
    to_port    = 22
  }

  ingress {    /* Rule # 124*/
    protocol   = "tcp"
    rule_no    = 124
    action     = "allow"
    cidr_block = "${var.priv_sub_1a}"
    from_port  = 22
    to_port    = 22
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
    "Name", "${var.acls_pub_prod_tg} - ${var.vpc_tg}",
    "Environment", "${var.vpc_tg}",
    "Client", "JCS"
    ))}"
}