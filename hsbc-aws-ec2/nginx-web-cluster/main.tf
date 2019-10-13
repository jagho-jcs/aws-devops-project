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

data "aws_security_group" "web-instance-sg" {
  filter {
    name = "tag:Name"
    values = ["SSH"]
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

resource "aws_instance" "web-instance" {
  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  connection {
    # The default username for our AMI
    type                  = "ssh"
    user                  = "ubuntu"
    host                  = "${self.public_ip}"
    private_key           = file(var.private_key_path)
    # The connection will use the local SSH agent for authentication.
  }
  
  count                   = length(data.aws_subnet_ids.hsbc-subnets.ids)

  instance_type           = "${var.instance_type}"

  user_data = <<-EOF
                #!/bin/bash
                hostname="hsbc-demo-sprgbtsvr"
                hostnamectl set-hostname $hostname
                sudo sed -i " 1 s/.*/& $hostname/" /etc/hosts
                EOF

  ami                     = "${data.aws_ami.ubuntu.id}"

  key_name                = "${aws_key_pair.auth-key.id}"
  
  vpc_security_group_ids  = [ data.aws_security_group.web-instance-sg.id ]

  subnet_id               = tolist(data.aws_subnet_ids.hsbc-subnets.ids)[count.index]

  provisioner "file" {
    source      = "./../../java-spring-boot-app/demo-0.0.1-SNAPSHOT.jar"
    destination = "/tmp/demo-0.0.1-SNAPSHOT.jar"
  } 

  provisioner "file" {
    source      = "./../../java-spring-boot-app/scripts/helloworld.service"
    destination = "/tmp/helloworld.service"
  }

  provisioner "file" {
    source      = "./../../java-spring-boot-app/scripts/helloworld.service"
    destination = "/tmp/helloworld.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get -y upgrade",
      "sudo apt-get update",
      "sudo unattended-upgrade",
      "sudo apt-get update",
      "sudo apt-get install -y openjdk-8-jdk",      
      "sudo apt-get update",
      "sudo apt-get -y install nginx",
      "sudo systemctl start nginx",
      "sudo apt-get -y upgrade",
      "sudo mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak",
      "sudo mv /tmp/helloworld.conf /etc/nginx/sites-available/helloworld.conf",
      "sudo apt-get autoremove -y",
      "sudo mkdir /opt/helloworld",
      "sudo mv /tmp/helloworld.service /etc/systemd/system/",
      "sudo mv /tmp/demo-0.0.1-SNAPSHOT.jar /opt/helloworld",
      "sudo systemctl start helloworld.service",
      "sudo ufw allow ssh",
      "sudo ufw allow 8080",
      "sudo ufw --force enable"
    ]
  }

    tags = "${merge(var.demo_env_default_tags, map(
    "Name", "${var.web_cluster}",
    "Client", "HSBC"
    ))}"
}

resource "aws_launch_configuration" "as_conf_web_instance" {
  
  name_prefix                       = "web-lc-web-instance-"
  image_id                          = "${data.aws_ami.ubuntu.id}"
  instance_type                     = "${var.instance_type}"
    
  lifecycle {

    create_before_destroy           = true
  }
  
}

resource "aws_autoscaling_group" "wb_instance_asg" {

  name                              = "Nginx Web Instance ASG"
  
  launch_configuration              = "${aws_launch_configuration.as_conf_web_instance.name}"
  
  vpc_zone_identifier               = flatten(["${data.aws_subnet.public.*.id}"])

  min_size                          = var.min_size
  max_size                          = var.max_size

  lifecycle {

    create_before_destroy           = true
  }
}

resource "aws_alb" "hsbc_alb" {

  name               = "HSBC-Nginx-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [ data.aws_security_group.alb_hsbc_sg.id, data.aws_security_group.web-instance-sg.id ]
  
  subnets            = data.aws_subnet.public.*.id
  
  tags = {
    Environment = "hsbc-demo-alb"
  }
}

resource "aws_alb_target_group_attachment" "hsbc_nginx_grp_att" {

  count             = length(data.aws_subnet_ids.hsbc-subnets.ids)
  target_group_arn  = aws_alb_target_group.hsbc_nginx_tgrp.arn
  target_id         = element(aws_instance.web-instance.*.id, count.index)
  port              = var.aws_alb_target_group_attachment_port

}

resource "aws_alb_target_group" "hsbc_nginx_tgrp" {
  
  name              = "HSBC-NginxTargetGroup"
  port              = var.aws_alb_target_group_port
  protocol          = "HTTP"
  vpc_id            = data.aws_vpc.hsbc-demo.id
}

resource "aws_autoscaling_attachment" "asg_att_hsbc_nginx" {
  
  autoscaling_group_name = "${aws_autoscaling_group.wb_instance_asg.id}"
  alb_target_group_arn   = "${aws_alb_target_group.hsbc_nginx_tgrp.arn}"
}

resource "aws_alb_listener" "front_end" {
  
  load_balancer_arn = "${aws_alb.hsbc_alb.arn}"
  port              = var.aws_alb_listener_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.hsbc_nginx_tgrp.arn}"
    type = "forward"
  }
}