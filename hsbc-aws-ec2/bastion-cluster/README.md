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


Assuming that the web servers on these Window and Linux machines are running on default ports, we need to enable public access to port 80.

All other ports should be blocked.  The Bastion host needs to `SSH` to port 80 on the Linux Server and RDP port 3389 on the Windows Server so that it can be used for remote access to these machines.

For this project, I have created one security group for both types of instances `PrivateSG`.

There is an assumption here that we are not using the default Network Access Control List (NACL) for the subnets which allows all the traffic and the deployment reflects this.

You will notice that I am not using the default so this will need to be configured.

The default build will also enable the ubuntu `UFW` this is currently setup to only allow `SSH`. 