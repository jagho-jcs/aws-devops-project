region                                    = "eu-west-1"

web_cluster                               = "web_cluster"

key_name                                  = "hsbc_demo_web_cluster"

public_key_path                           = "~/.ssh/hsbc_demo.pub"

private_key_path                          = "~/.ssh/hsbc_demo"

instance_type                             = "t2.micro"

ssh_cidr_blocks                           = ["0.0.0.0/0"]

ssl_cidr_blocks                           = ["0.0.0.0/0"]

http_cidr_blocks                          = ["0.0.0.0/0"]

https_cidr_blocks                         = ["0.0.0.0/0"]

min_size                                  = 1

max_size                                  = 1

aws_alb_target_group_attachment_port      = 8080

aws_alb_target_group_port                 = 8080

aws_alb_listener_port                     = 80