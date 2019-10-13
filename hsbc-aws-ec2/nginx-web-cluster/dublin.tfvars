aws_region                                = "eu-west-1"

key_name                                  = "hsbc_demo_ireland"

public_key_path                           = "~/.ssh/hsbc_demo_ireland.pub"

private_key_path                          = "~/.ssh/hsbc_demo_ireland"

instance_type                             = "t2.micro"

ssh_cidr_blocks                           = ["188.28.161.5/32"]

ssl_cidr_blocks                           = ["92.40.46.60/32"]

http_cidr_blocks                          = ["92.40.46.60/32"]

https_cidr_blocks                         = ["92.40.46.60/32"]

min_size                                  = 1

max_size                                  = 1

aws_alb_target_group_attachment_port      = 8080

aws_alb_target_group_port                 = 8080

aws_alb_listener_port                     = 80