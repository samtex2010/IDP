resource "aws_instance" "ec2" {
  ami                         = local.ami_id
  instance_type               = local.instance_type
  key_name                    = local.ssh_key
  subnet_id                   = local.subnet_id
  vpc_security_group_ids      = var.sg_enable ? [aws_security_group.ec2[0].id] : var.ec2_sgs_from_vpc
  associate_public_ip_address = local.public_ip
  private_ip                  = cidrhost(local.cidr_block, var.host_net_numb)
  iam_instance_profile        = var.iam_instance_profile
  source_dest_check           = var.source_dest_check
  ebs_optimized               = var.ebs_optimized

  root_block_device {
    volume_size           = local.disk_size
    delete_on_termination = true
    volume_type           = "gp3"
  }

  lifecycle {
    ignore_changes = [ami]
  }

  tags = merge(
    var.aws_tags, {
      Name    = local.instane_name
      Project = local.project
  })

  user_data = var.user_data
}
