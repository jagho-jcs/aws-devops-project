# data "aws_vpc" "hsbc-demo" {
#   filter {
#     name = "tag:Name"
#     values = ["hsbc-demo"]
#   }
# }

# resource "aws_security_group" "web-instance-sg" {
#   name              = "web-instance-sg"
#   description       = "Allows Access for the nginx app"
#   vpc_id            = "${data.aws_vpc.hsbc-demo.id}"

#   ingress {
#     description     = "Allows unsecure traffic to the nginx"
#     from_port       = 80
#     to_port         = 80
#     protocol        = "tcp"
#     cidr_blocks     = ["0.0.0.0/0"]
#   }

#   ingress {
#     description     = "Allows secure traffic from the nginx app"
#     from_port       = 443
#     to_port         = 443
#     protocol        = "tcp"
#     cidr_blocks     = ["0.0.0.0/0"]
#   }

#   ingress {
#     description     = "Allows traffic to the nginx"
#     from_port       = 8080
#     to_port         = 8080
#     protocol        = "tcp"
#     cidr_blocks     = ["0.0.0.0/0"]
#   }

#   ingress {
#     description     = "Allows ssh access to the web instance"
#     from_port       = 22
#     to_port         = 22
#     protocol        = "tcp"
#     cidr_blocks     = ["188.28.161.5/32"]
#   }

#   egress {
#     from_port       = 0
#     to_port         = 0
#     protocol        = "-1"
#     cidr_blocks     = ["0.0.0.0/0"]
#   }
    
#     tags = "${merge(var.demo_env_default_tags, map(
#     "Name", "${var.ssh_admin_tg}",
#     "Environment", "${var.vpc_tg}",
#     "Client", "HSBC",
#     "Project", "aws-devops-terraform"
#     ))}"
# }

# resource "aws_security_group" "alb_hsbc_sg" {
  
#   name                              = "hsbc_nginx_sg_alb"
#   description                       = "hsbc-aws DevOps Project"
#   vpc_id                            = "${data.aws_vpc.hsbc-demo.id}"

#   ingress {
#     description     = "Allows http traffic to the Application Load Balancer"
#     from_port       = 80
#     to_port         = 80
#     protocol        = "tcp"
#     cidr_blocks     = ["0.0.0.0/0"]
#   }

#   ingress {
#     description     = "Allows http traffic to the Application Load Balancer"
#     from_port       = 8080
#     to_port         = 8080
#     protocol        = "tcp"
#     cidr_blocks     = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port       = 0
#     to_port         = 0
#     protocol        = "-1"
#     cidr_blocks     = ["0.0.0.0/0"]
#   }

#     tags = "${merge(var.demo_env_default_tags, map(
#     "Name", "${var.ire_alb_tg}",
#     "Environment", "${var.vpc_tg}",
#     "Client", "HSBC",
#     "Project", "aws-devops-terraform"
#     ))}"
# }