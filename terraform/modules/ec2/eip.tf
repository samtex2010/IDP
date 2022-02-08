resource "aws_eip" "eip" {
  count = var.eip_enable ? 1 : 0

  instance = aws_instance.ec2.id
  vpc      = true

  tags = merge(
    var.aws_tags, {
      Name    = "${local.instane_name}-eip"
      Project = local.project
  })
}

resource "aws_eip_association" "eip_assoc" {
  count = var.eip_from_vpc ? 1 : 0

  instance_id   = aws_instance.ec2.id
  allocation_id = var.eip_from_vpc_id
}