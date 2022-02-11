data "aws_iam_policy_document" "enhanced_monitoring" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"
      identifiers = [
        "monitoring.rds.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "enhanced_monitoring" {
  name               = "${local.project_idp}-RDS-IAM-ROLE"
  assume_role_policy = data.aws_iam_policy_document.enhanced_monitoring.json

  tags = merge(
    var.aws_tags, {
      Project = local.project_idp
      Name    = "${local.project_idp}-RDS-IAM-ROLE"
    }
  )
}

resource "aws_iam_role_policy_attachment" "enhanced_monitoring_attachment" {
  role       = aws_iam_role.enhanced_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}