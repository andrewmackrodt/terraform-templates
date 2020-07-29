module "php_apache_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"

  name               = "php-apache-alb"
  load_balancer_type = "application"
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets

  security_groups = [
    aws_security_group.public_alb.id,
  ]

  //  # See notes in README (ref: https://github.com/terraform-providers/terraform-provider-aws/issues/7987)
  //  access_logs = {
  //    bucket = module.log_bucket.this_s3_bucket_id
  //  }

  target_groups = [
    {
      name                 = "php-apache-tg"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "instance"
      deregistration_delay = 300
      health_check = {
        enabled             = true
        healthy_threshold   = 5
        unhealthy_threshold = 2
        timeout             = 5
        interval            = 30
        port                = "traffic-port"
        protocol            = "HTTP"
        path                = "/"
        matcher             = "200-299"
      }
    },
  ]

  http_tcp_listeners = [
    {
      protocol    = "HTTP"
      port        = 80
      action_type = "redirect"
      redirect = {
        protocol    = "HTTPS"
        port        = 443
        status_code = "HTTP_301"
      }
    },
  ]

  https_listeners = [
    {
      certificate_arn    = aws_acm_certificate_validation.default.0.certificate_arn
      protocol           = "HTTPS"
      port               = 443
      target_group_index = 0
    },
  ]

  tags = local.common_tags
}

module "php_apache_asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name          = "php-apache"
  image_id      = compact([var.default_ami_id, data.aws_ami.ubuntu-focal.id])[0]
  instance_type = var.default_instance_type
  key_name      = var.ssh_key_name

  security_groups = [
    aws_security_group.private_web.id,
  ]

  root_block_device = [
    {
      volume_size = "50"
      volume_type = "gp2"
    },
  ]

  # auto scaling group
  asg_name                  = "php-apache-asg"
  vpc_zone_identifier       = module.vpc.private_subnets
  health_check_type         = "ELB"
  min_size                  = 2
  max_size                  = 3
  desired_capacity          = 2
  wait_for_capacity_timeout = 0

  # target groups
  target_group_arns = module.php_apache_alb.target_group_arns

  # cloud-init
  user_data = base64encode(file("./cloud-init/php-apache.yaml"))

  tags_as_map = local.common_tags
}
