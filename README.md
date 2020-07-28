# terraform-templates

**WIP** [Terraform][terraform] templates for use with [AWS][aws], presently sets
up a VPC with 2 availability zones, private and public subnets, internet gateway,
security groups, a single AZ bastion host and an auto-scaling apache/php7.4
service behind an application load-balancer with SSL.

## Quick Start

1. Execute `terraform init` to initialize the terraform environment.
1. Create and populate the file `user.auto.tfvars` in the project root:
   ```
   environment = "production"
   access_key = ""
   secret_key = ""
   region = "eu-west-2"
   ssh_key_name = ""
   certificate_arn = ""
   ```
1. Execute `terraform apply` to generate the environment.

## Useful Commands

```sh
# apply all changes without prompt (caution)
terraform apply -auto-approve

# generate a change plan
terraform plan -out=pending.tfstate

# apply a change plan
terraform apply -state=pending.tfstate

# apply a change plan without prompt
terraform apply -state=pending.tfstate -auto-approve
```

[terraform]: https://www.terraform.io/
[aws]: https://aws.amazon.com/
