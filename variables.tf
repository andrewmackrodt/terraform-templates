variable "cidr" {
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  default = [
    "eu-west-2a",
    "eu-west-2b",
    "eu-west-2c",
  ]
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

variable "bastion_instance_type" {
  default = ""
}

variable "bastion_ssh_key_name" {
  default = ""
}

variable "access_key" {}
variable "secret_key" {}
variable "ssh_key_name" {}
variable "certificate_arn" {}
