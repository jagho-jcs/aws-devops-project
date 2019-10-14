# Nginx Web Cluster As Reverse Proxy

Configuration in this directory creates Nginx web cluster with minimum set of arguments.

This example outputs instance id and public DNS name as a single value and as a list.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply -var-file=dublin.tfvars
```

Note that this example may create resources which can cost money. Run `terraform destroy` when you don't need these resources.

## Outputs

| Name | Description |
|------|-------------|
| alb_address| address of the alb created |
| subnet_ids | List of subnet |
| vpc_id | VPC IDs |


```
curl http://<alb_address>
Hello, World
```