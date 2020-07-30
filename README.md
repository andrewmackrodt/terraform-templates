# terraform-templates

**WIP** [Terraform][terraform] templates for use with [AWS][aws], presently creates:

- a VPC with 2 availability zones
- private and public subnets in each availability zone
- internet gateway
- security groups
- bastion host to access private network
- an auto-scaling apache/php7.4 service behind an ALB with SSL
- dns management for setting ACM validation keys in Cloudflare
- dns management for setting SES DKIM keys in Cloudflare

## Quick Start

1. Execute `terraform init` to initialize the terraform environment.
1. Create and populate the file `user.auto.tfvars` in the project root:
   ```
   environment = "production"
   access_key = ""
   secret_key = ""
   region = "eu-west-2"
   ssh_key_name = ""
   default_domain = "domain.com"

   # optional: https://dash.cloudflare.com/profile/api-tokens
   cloudflare_api_token = ""
   ```
1. Execute `terraform apply` to generate the environment.

## Required Reading for AWS Accounts with Existing Resources

**default_domain**

Terraform will attempt to create the specified domain in ACM. If the domain
already exists, users **may** import it into their Terraform config by
executing `terraform import aws_acm_certificate.default "arn:aws:acm:________"`.

Terraform will attempt to create the specified domain in SES. If the domain
already exists, users **must** import it into their Terraform config by
executing `terraform import aws_ses_domain_identity.default "domain.com"`.

**cloudflare_api_token**

Setting the Cloudflare API Token is an optional but recommended step. Terraform
will attempt to create the zone automatically and manage DNS entries for things
such as DKIM verification. If the domain already exists, users **must** import
it into their Terraform config by executing `terraform import cloudflare_zone.default "Zone ID"`
where `Zone ID` is available via the Cloudflare Overview page for the domain in
question.

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
