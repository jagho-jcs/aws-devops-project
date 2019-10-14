data "aws_availability_zones" "all" {}

data "aws_vpc" "hsbc-demo" {
  filter {
    name = "tag:Name"
    values = ["hsbc-demo"]
  }
}

data "aws_subnet_ids" "hsbc-subnets" {
  vpc_id = "${data.aws_vpc.hsbc-demo.id}"

  tags = {
    Name = "Public Subnet"
  }
}

output "vpc_id" {
  value = ["${data.aws_subnet_ids.hsbc-subnets.*.id}"]
}

data "aws_subnet" "public" {
  count = length(data.aws_subnet_ids.hsbc-subnets.ids)
  id    = tolist(data.aws_subnet_ids.hsbc-subnets.ids)[count.index]
}

data "aws_subnet_ids" "my_id" {
  vpc_id = "${data.aws_vpc.hsbc-demo.id}"
}

output "subnet_ids" {
  value = ["${data.aws_subnet_ids.my_id.*.ids}"]
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

data "aws_security_group" "bastion-sg" {
  filter {
    name = "tag:Name"
    values = ["BastionSG"]
  }
}

data "aws_security_group" "alb_hsbc_sg" {
  filter {
    name = "tag:Name"
    values = ["InFacingALB"]
  }
}

resource "aws_key_pair" "auth-key" {

  key_name                = "${var.key_name}"
  public_key              = "${file(var.public_key_path)}"
  
}

resource "aws_instance" "bastion-host" {
  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  connection {
    # The default username for our AMI
    type                  = "ssh"
    user                  = "ubuntu"
    host                  = "${self.public_ip}"
    private_key           = file(var.private_key_path)
    # The connection to use for the local SSH agent for authentication.
  }
  
  count                   = length(data.aws_subnet_ids.hsbc-subnets.ids)

  instance_type           = "${var.instance_type}"

  user_data = <<-EOF
                #!/bin/bash
                hostname="hsbc-demo-bastion"
                hostnamectl set-hostname $hostname
                sudo sed -i " 1 s/.*/& $hostname/" /etc/hosts
                EOF

  ami                     = "${data.aws_ami.ubuntu.id}"

  key_name                = "${aws_key_pair.auth-key.id}"
  
  vpc_security_group_ids  = [ data.aws_security_group.bastion-sg.id ]

  subnet_id               = tolist(data.aws_subnet_ids.hsbc-subnets.ids)[count.index]

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get -y upgrade",
      "sudo apt-get update",
      "sudo unattended-upgrade",
      "sudo ufw allow ssh",
      "sudo ufw --force enable"
    ]
  }

    tags = "${merge(var.demo_env_default_tags, map(
    "Name", "${var.bastion_host}",
    "Client", "HSBC"
    ))}"
}

resource "aws_launch_configuration" "as_conf_bastion_instance" {
  
  name_prefix                       = "bastion-lc-"
  image_id                          = "${data.aws_ami.ubuntu.id}"
  instance_type                     = "${var.instance_type}"
    
  lifecycle {

    create_before_destroy           = true
  }
  
}

resource "aws_autoscaling_group" "bastion_asg" {

  name                              = "Bastion-Jump-Box ASG"
  
  launch_configuration              = "${aws_launch_configuration.as_conf_bastion_instance.name}"
  
  vpc_zone_identifier               = flatten(["${data.aws_subnet.public.*.id}"])

  min_size                          = var.min_size
  max_size                          = var.max_size

  lifecycle {

    create_before_destroy           = true
  }
}
