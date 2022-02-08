resource "aws_security_group" "rds-sg" {
  count = var.sg_enable ? 1 : 0

  name   = "${local.project}-RDS-SG"
  vpc_id = local.vpc_id

  tags = merge(
    var.aws_tags, {
      Project = local.project
      Name    = "${local.project}-rds-sg"
    }
  )

}

# Ingress Security Port 5432
resource "aws_security_group_rule" "pg_inbound_access" {
  count = var.sg_enable ? 1 : 0

  from_port         = 5432
  protocol          = "tcp"
  security_group_id = aws_security_group.rds-sg[0].id
  to_port           = 5432
  type              = "ingress"
  cidr_blocks       = var.allowed_hosts
}
