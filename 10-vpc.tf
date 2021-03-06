module "vpc" {
  source = "git::https://github.com/andrewmackrodt/terraform-aws-vpc.git"

  name = var.name

  # cidr (default: "10.0.0.0/16")
  cidr = var.cidr

  # availability zones (default: ["eu-west-2a", "eu-west-2b"])
  azs = slice(data.aws_availability_zones.available.names, 0, var.availability_zone_count)

  # public subnets (default: ["10.0.0.0/22", "10.0.4.0/22"])
  public_subnets  = slice(var.public_subnets, 0, var.availability_zone_count)

  # private subnets (default: ["10.0.32.0/21", "10.0.40.0/21"])
  private_subnets = slice(var.private_subnets, 0, var.availability_zone_count)

  # dns support
  enable_dns_hostnames = true
  enable_dns_support   = true

  # nat gateway - 1 per availability zone
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  # s3 endpoint
  enable_s3_endpoint = true

  # vpn gateway
  enable_vpn_gateway = true

  # resource name customization
  internet_gateway_suffix = "igw"
  nat_gateway_suffix = "nat"
  route_table_suffix = "rt"
  vpn_gateway_suffix = "vpn"
  numeric_az_tags = true

  # resource tags
  tags = local.common_tags
}
