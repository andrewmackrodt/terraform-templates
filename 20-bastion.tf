module "bastion_nlb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"

  name               = "bastion-nlb"
  load_balancer_type = "network"
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets

  //  # See notes in README (ref: https://github.com/terraform-providers/terraform-provider-aws/issues/7987)
  //  access_logs = {
  //    bucket = module.log_bucket.this_s3_bucket_id
  //  }

  target_groups = [
    {
      name                 = "bastion-tg"
      backend_protocol     = "TCP"
      backend_port         = 22
      target_type          = "instance"
      deregistration_delay = 30
    },
  ]

  http_tcp_listeners = [
    {
      protocol = "TCP"
      port     = 22
    },
  ]

  tags = local.common_tags
}

module "bastion_asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name          = "bastion"
  image_id      = compact([var.default_ami_id, data.aws_ami.ubuntu-focal.id])[0]
  instance_type = var.default_instance_type
  key_name      = var.ssh_key_name

  security_groups = [
    aws_security_group.bastion.id,
  ]

  root_block_device = [
    {
      volume_size = "50"
      volume_type = "gp2"
    },
  ]

  # auto scaling group
  asg_name                  = "bastion-asg"
  vpc_zone_identifier       = module.vpc.private_subnets
  health_check_type         = "ELB"
  min_size                  = 1
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0

  # target groups
  target_group_arns = module.bastion_nlb.target_group_arns

  # cloud-init
  user_data = base64encode(file("./cloud-init/bastion.yaml"))

  tags_as_map = local.common_tags
}
