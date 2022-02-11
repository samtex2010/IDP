data "aws_kms_alias" "rds" {
  name = "alias/aws/rds"
}

resource "aws_db_subnet_group" "rds-private-subnet" {
  name       = "${lower(local.project_idp)}_db_sng"
  subnet_ids = local.private_subnet_ids

  tags = merge(
    var.aws_tags, {
      Project = local.project_idp
      Name    = "${local.project_idp}-DB-SNG"
    }
  )

}

resource "aws_db_instance" "pg" {
  allocated_storage           = local.storage_size
  storage_type                = "gp2"
  engine                      = "postgres"
  engine_version              = local.engine_version
  instance_class              = local.instance_type
  identifier                  = "${lower(local.project_idp)}-rds"
  snapshot_identifier         = var.snapshot_identifier
  username                    = local.db_user
  password                    = var.db_password
  parameter_group_name        = local.parameter_group_name
  db_subnet_group_name        = aws_db_subnet_group.rds-private-subnet.name
  vpc_security_group_ids      = var.sg_enable ? [aws_security_group.rds-sg[0].id] : var.rds_sgs_from_vpc
  allow_major_version_upgrade = local.major_version_upgrade
  auto_minor_version_upgrade  = local.minor_version_upgrade
  backup_retention_period     = local.retention_period
  backup_window               = "22:00-23:00"
  maintenance_window          = "Sat:00:00-Sat:03:00"
  apply_immediately           = var.apply_immediately
  multi_az                    = local.multi_az
  skip_final_snapshot         = local.skip_final_snapshot
  kms_key_id                  = var.storage_encrypted ? data.aws_kms_alias.rds.target_key_arn : null
  storage_encrypted           = var.storage_encrypted
  deletion_protection         = var.deletion_protection
  monitoring_interval         = 5
  monitoring_role_arn         = aws_iam_role.enhanced_monitoring.arn
  enabled_cloudwatch_logs_exports = [
    "postgresql",
    "upgrade"
  ]

  tags = merge(
    var.aws_tags, {
      Project = local.project_idp
      Name    = "${local.project_idp}-RDS"
    }
  )

}
