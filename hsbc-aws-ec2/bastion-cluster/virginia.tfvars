region                                    = "us-east-1"

bastion_host                              = "bastion-host"

key_name                                  = "hsbc_demo_bastion"

public_key_path                           = "~/.ssh/hsbc_demo.pub"

private_key_path                          = "~/.ssh/hsbc_demo"

instance_type                             = "t2.micro"

ssh_cidr_blocks                           = ["94.196.181.227/32"]

ssl_cidr_blocks                           = ["94.196.181.227/32"]

http_cidr_blocks                          = ["94.196.181.227/32"]

https_cidr_blocks                         = ["94.196.181.227/32"]

min_size                                  = 1

max_size                                  = 1