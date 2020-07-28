provider "aws" {
  version    = "~> 2.7"
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

locals {
  common_tags = {
    Environment = var.environment
    Terraform = "true"
  }
}
