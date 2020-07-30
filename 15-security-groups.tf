resource "aws_security_group" "bastion" {
  name   = "bastion-sg"
  vpc_id = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = var.bastion_cidr_blocks
    content {
      description = "Allow ssh from ${ingress.value.description}"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [ingress.value.value]
    }
  }

  egress {
    description = "Allow all to any"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "bastion-sg"
  })
}

resource "aws_security_group" "public_alb" {
  name   = "public-alb-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "Allow ping from any"
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow http from any"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow https from any"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all to any"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "public-alb-sg"
  })
}

resource "aws_security_group" "private_web" {
  name   = "private-web-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    description     = "Allow ssh from private bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  ingress {
    description     = "Allow http from public alb"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.public_alb.id]
  }

  ingress {
    description     = "Allow https from public alb"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.public_alb.id]
  }

  egress {
    description = "Allow all to any"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "private-web-sg"
  })
}
