variable "allowed_hosts" {
  description = "CIDR blocks of trusted networks"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "private_subnet_ids" {}

data "aws_subnet" "private" {
  id = local.private_subnet_ids.0
}

variable "project" {}

variable "aws_tags" {
  type    = map(any)
  default = {}
}

variable "storage_size" {
  default = 20
}

variable "instance_type" {
  default = "db.t3.small"
}

variable "engine_version" {
  default = "9.6.21"
}

variable "parameter_group_name" {
  default = "default.postgres9.6"
}

variable "major_version_upgrade" {
  default = true
}

variable "minor_version_upgrade" {
  default = false
}

variable "retention_period" {
  default = 7
}

variable "multi_az" {
  default = false
}

variable "skip_final_snapshot" {
  default = true
}

variable "db_user" {
  default = "postgres"
}

variable "db_name" {
  default = "postgresdb"
}

variable "apply_immediately" {
  default = false
}

variable "sg_enable" {
  default = true
}

variable "rds_sgs_from_vpc" {
  default = []
}

variable "deletion_protection" {
  default = true
}

variable "storage_encrypted" {
  default = true
}

variable "snapshot_identifier" {
  default = null
}

variable "db_password" {}

data "aws_caller_identity" "current" {}

locals {
  vpc_id                = data.aws_subnet.private.vpc_id
  private_subnet_ids    = var.private_subnet_ids
  project               = var.project
  storage_size          = var.storage_size
  instance_type         = var.instance_type
  engine_version        = var.engine_version
  parameter_group_name  = var.parameter_group_name
  major_version_upgrade = var.major_version_upgrade
  minor_version_upgrade = var.minor_version_upgrade
  retention_period      = var.retention_period
  multi_az              = var.multi_az
  skip_final_snapshot   = var.skip_final_snapshot
  db_user               = var.db_user
  account_id            = data.aws_caller_identity.current.account_id
}
