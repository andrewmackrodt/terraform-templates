resource "aws_instance" "bastion" {
  ami           = compact([var.bastion_ami_id, var.default_ami_id, data.aws_ami.ubuntu-focal.id])[0]
  instance_type = var.bastion_instance_type != "" ? var.bastion_instance_type : var.default_instance_type
  subnet_id     = module.vpc.public_subnets[0]
  key_name      = var.bastion_ssh_key_name != "" ? var.bastion_ssh_key_name : var.ssh_key_name

  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.bastion.id,
  ]

  # cloud-init
  user_data_base64 = base64encode(file("./cloud-init/bastion.yaml"))

  tags = merge(local.common_tags, {
    Name = "${var.name}-bastion"
  })
}

resource "aws_eip" "lb" {
  instance = aws_instance.bastion.id
  vpc      = true

  tags = merge(local.common_tags, {
    Name = "${var.name}-bastion-eip"
  })
}
