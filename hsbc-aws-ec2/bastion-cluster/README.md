# Bastion Cluster

Configuration in this directory will create a Bastion Cluster.

This example outputs subnet ids, instance public IPs, and the vpc_id as a single value and as a list.


## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply -var-file=dublin.tfvars
```

Note that this example may create resources which you maybe charged. 

Run `terraform destroy` when you don't need these resources.

## Outputs

| Name | Description |
|------|-------------|
| alb_address| address of the alb created |
| subnet_ids | List of subnet |
| vpc_id | VPC IDs |
| instance_public_ips | List of Public IPs |