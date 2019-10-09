data "aws_vpc" "hsbc-demo" {
  filter {
    name = "tag:Name"
    values = ["hsbc-demo"]
  }
}

data "aws_subnet" "selected" {
  id = "${var.subnet_id}"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/*ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_security_group" "web-instance-sg" {
  name              = "web-instance-sg"
  description       = "Allows Access for the nginx app"

  vpc_id            = "${data.aws_vpc.hsbc-demo.id}"

  ingress {
    description     = "Allows unsecure traffic to the nginx"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = "${var.http_cidr_blocks}"
  }

  ingress {
    description     = "Allows secure traffic from the nginx app"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = "${var.https_cidr_blocks}"
  }

  ingress {
    description     = "Allows traffic to the nginx"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    description     = "Allows ssh access to the web instance"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = "${var.ssh_cidr_blocks}"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  # tags = "${merge(var.demo_env_default_tags, map(
  #   "Name", "${var.jcswebapps_tg}",
  #   "Environment", "${var.vpc_tg}",
  #   "Client", "HSBC"
  #   ))}"
}

resource "aws_key_pair" "auth-key" {
  key_name                = "${var.key_name}"
  # public_key              = "${var.public_key}"
  public_key              = "${file(var.public_key_path)}"
  # public_key              = "${file(var.public_key)}"
}

resource "aws_instance" "web-instance" {
  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  connection {
    # The default username for our AMI
    user = "ubuntu"
    host = "${self.public_ip}"
    # The connection will use the local SSH agent for authentication.
  }
  
  instance_type           = "${var.instance_type}"

  ami                     = "${data.aws_ami.ubuntu.id}"

  key_name                = "${aws_key_pair.auth-key.id}"
  
  vpc_security_group_ids  = [ "${aws_security_group.web-instance-sg.id}" ]
  
  subnet_id               = "${data.aws_subnet.selected.id}"

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install nginx",
      "sudo systemctl start nginx",
    ]
  }
}

