variable "cidr" {
  default = "10.0.0.0/16"
}

variable "availability_zone_count" {
  default = 2
}

variable "public_subnets" {
  default = [
    "10.0.0.0/22",
    "10.0.4.0/22",
    "10.0.8.0/22",
  ]
}

variable "private_subnets" {
  default = [
    "10.0.32.0/21",
    "10.0.40.0/21",
    "10.0.48.0/21",
  ]
}

variable "region" {
  default = "eu-west-2"
}

variable "environment" {
  default = "production"
}

variable "name" {
  default = "terraform"
}

variable "default_ami_id" {
  default = ""
}

variable "default_instance_type" {
  default = "t2.micro"
}


variable "bastion_ami_id" {
  default = ""
}

variable "bastion_cidr_blocks" {
  default = [
    {
      description = "any"
      value = "0.0.0.0/0"
    }
  ]
}

variable "bastion_instance_type" {
  default = ""
}

variable "bastion_ssh_key_name" {
  default = ""
}

variable "bastion_subdomain" {
  default = ""
}

variable "access_key" {}
variable "secret_key" {}
variable "ssh_key_name" {}

variable "cloudflare_api_token" {
  description = "Setting the Cloudflare API Token enables automatic DNS updates for things like setting TXT records for domain verification and assigning a domain to an ALB."
  default = ""
}

variable "default_domain" {}

variable "default_mx_records" {
  default = []
}
