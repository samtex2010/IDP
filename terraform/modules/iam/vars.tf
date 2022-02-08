variable "project" {
  description = "Project tag."
}

data "aws_caller_identity" "current" {}

locals {
  project    = var.project
  account_id = data.aws_caller_identity.current.account_id
}

variable "aws_tags" {
  type    = map(any)
  default = {}
}