# Define a vpc
resource "aws_vpc" "default" {
  count = var.create_vpc ? 1 : 0

  cidr_block                = "${var.vpc_cidr_block}"
  enable_dns_hostnames      = true

  tags = "${merge(var.demo_env_default_tags, map(
    "Name", "${var.vpc_tg}",
    "Client", "HSBC"
    ))}"
}

resource "aws_security_group" "web-instance-sg" {
  name              = "web-instance-sg"
  description       = "Allows Access for the nginx app"
  vpc_id            = "${aws_vpc.default[0].id}"

  ingress {
    description     = "Allows unsecure traffic to the nginx"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]   # This is allows inbound traffic from the Internet to reach our Application
  }

  ingress {
    description     = "Allows secure traffic from the nginx app"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]   # This allows inbound traffic from the Internet to reach our Application
  }

  ingress {
    description     = "Allows traffic to the nginx"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]   # This allows inbound traffic from the Internet to reach our Application
  }

  ingress {
    description     = "Allows ssh access to the web instance"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = var.ssh_cidr_blocks
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]   # This allows outbound traffic from the Application
  }
    
    tags = "${merge(var.demo_env_default_tags, map(
    "Name", "${var.ssh_admin_tg}",
    "Environment", "${var.vpc_tg}",
    "Client", "HSBC",
    "Project", "aws-devops-terraform"
    ))}"
}

resource "aws_security_group" "alb_hsbc_sg" {
  
  name                              = "hsbc_nginx_sg_alb"
  description                       = "hsbc-aws DevOps Project"
  vpc_id                            = "${aws_vpc.default[0].id}"

  ingress {
    description     = "Allows http traffic to the Application Load Balancer"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]  # This allows outbound traffic from the Application
  }

  ingress {
    description     = "Allows http traffic to the Application Load Balancer"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

    tags = "${merge(var.demo_env_default_tags, map(
    "Name", "${var.dub_alb_tg}",
    "Environment", "${var.vpc_tg}",
    "Client", "HSBC",
    "Project", "aws-devops-terraform"
    ))}"
}
resource "aws_security_group" "bastion-sg" {
  name              = "bastion-sg"
  description       = "Bastion Jump Box"
  vpc_id            = "${aws_vpc.default[0].id}"

  ingress {
    description     = "Allows ssh access to bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]  # This allows inbound traffic for the Bastion
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"] # This allows outbound traffic from the Bastion
  }
    
    tags = "${merge(var.demo_env_default_tags, map(
    "Name", "${var.ssh_bastion_tg}",
    "Environment", "${var.vpc_tg}",
    "Client", "HSBC",
    "Project", "aws-devops-terraform"
    ))}"
}
resource "aws_security_group" "private-sg" {
  name              = "private-sg"
  description       = "Bastion Jump Box"
  vpc_id            = "${aws_vpc.default[0].id}"

  ingress {
    description     = "Public HTTP Access"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    description     = "Bastion RDP Access"
    from_port       = 3389
    to_port         = 3389
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
    
    tags = "${merge(var.demo_env_default_tags, map(
    "Name", "${var.ssh_private_tg}",
    "Environment", "${var.vpc_tg}",
    "Client", "HSBC",
    "Project", "aws-devops-terraform"
    ))}"
}
