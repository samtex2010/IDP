resource "aws_security_group" "ec2" {
  count = var.sg_enable ? 1 : 0

  name        = "${local.instane_name}-SG"
  description = "${local.instane_name}-SG"
  vpc_id      = local.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
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
      Name    = "${local.instane_name}-SG"
    }
  )
}