region                                    = "us-east-1"

bastion_host                              = "bastion-host"

key_name                                  = "hsbc_demo_bastion"

public_key_path                           = "~/.ssh/hsbc_demo.pub"

private_key_path                          = "~/.ssh/hsbc_demo"

instance_type                             = "t2.micro"

ssh_cidr_blocks                           = ["0.0.0.0/0"]

ssl_cidr_blocks                           = ["0.0.0.0/0"]

http_cidr_blocks                          = ["0.0.0.0/0"]

https_cidr_blocks                         = ["0.0.0.0/0"]

min_size                                  = 1

max_size                                  = 1