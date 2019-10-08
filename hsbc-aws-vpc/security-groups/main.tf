/* These are default security groups that need to be setup for the 
    base infrastructure */

resource "aws_security_group" "ireland_alb" {
  name = "InFacingALB"
  description = "Allows all traffic from the Application Load Balancer"

  ingress {
    description = "Allows unsecure traffic from the load balancer"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allows secure traffic from the load balancer"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.demo_env_default_tags, map(
    "Name", "${var.ire_alb_tg}",
    "Environment", "${var.vpc_tg}",
    "Client", "JCS"
    ))}"
}

resource "aws_security_group" "ssh" {
  name = "SSH"
  description = "Allows admin access"

  ingress {
    description = "Allows admin access"
    from_port = 0
    to_port = 0
    protocol = -1
    self = true
  }

  tags = "${merge(var.demo_env_default_tags, map(
    "Name", "${var.ssh_admin_tg}",
    "Environment", "${var.vpc_tg}",
    "Client", "JCS"
    ))}"
}

resource "aws_security_group" "JCSWebAppsALB" {
  name = "JCSWebAppsALB"
  description = "Allows Access for the WebApps ALB"

  ingress {
    description = "Allows unsecure traffic to the WebApps"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allows secure traffic from the load balancer"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allows traffic to the WebApps"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.demo_env_default_tags, map(
    "Name", "${var.jcswebapps_tg}",
    "Environment", "${var.vpc_tg}",
    "Client", "JCS"
    ))}"
}

resource "aws_security_group" "jks_mstr" {
  name = "JenkinsMastersAutoScalingSecurityGroup"
  description = "Allows access to Jenkins"

  ingress {
    description = "Allows Access to the Jenkins Dashboard"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    
    from_port = 0
    to_port = 0
    protocol = -1
    self = true
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.demo_env_default_tags, map(
    "Name", "${var.jks_tg}",
    "Environment", "${var.vpc_tg}",
    "Client", "JCS"
    ))}"
}

resource "aws_security_group" "efs" {
  name = "EFS"
  description = "Allows EFS traffic"

  ingress {
    description = "Allows NFS traffic"
    from_port = 2049
    to_port = 2049
    protocol = "tcp"
    security_groups = ["${aws_security_group.ssh.id}", 
                        "${aws_security_group.jks_mstr.id}"]
  }

  # ingress {
  #   description = "Allows secure traffic from the load balancer"
  #   from_port = 443
  #   to_port = 443
  #   protocol = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.demo_env_default_tags, map(
    "Name", "${var.efs_tg}",
    "Environment", "${var.vpc_tg}",
    "Client", "JCS"
    ))}"
}

