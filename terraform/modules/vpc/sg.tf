resource "aws_security_group" "sg" {
  for_each = var.sg

  name        = "${each.key}-SG"
  description = "${each.key}-SG"
  vpc_id      = aws_vpc.main.id

  lifecycle {
    create_before_destroy = true
  }

  dynamic "ingress" {
    for_each = each.value.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_network]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.aws_tags, {
      Project = local.project
      Name    = "${each.key}-SG"
    }
  )
}