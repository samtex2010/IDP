variable "project_idp" {
  description = "Project IDP tag."
}

data "aws_caller_identity" "current" {}

locals {
  project_idp    = var.project_idp
  account_id = data.aws_caller_identity.current.account_id
}

variable "aws_tags" {
  type    = map(any)
  default = {}
}