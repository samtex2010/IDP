resource "aws_iam_role" "ec2-instance-role" {
  name = join("-", [local.project, "compute-instance-role"])

  assume_role_policy = <<POLICY
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.aws_tags, {
      Project = local.project
  })

}

resource "aws_iam_policy" "ec2-instance-role-policy" {
  name = join("-", [aws_iam_role.ec2-instance-role.name, "policy"])

  tags = merge(
    var.aws_tags, {
      Project = local.project
  })

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances",
        "ec2:DescribeInstanceTypes",
        "ec2:DescribeInstanceStatus"
      ],
      "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": [
            "ec2:DescribeAvailabilityZones",
            "ec2:DescribeRegions"
        ],
        "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "s3:ListMultipartUploadParts",
      "Resource": "arn:aws:s3:::*/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucketMultipartUploads",
        "s3:ListBucketVersions",
        "s3:ListBucket"
      ],
      "Resource": "arn:aws:s3:::*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListStorageLensConfigurations",
        "s3:ListAllMyBuckets",
        "s3:ListJobs"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "rds:DescribeDBProxyTargetGroups",
        "rds:DescribeDBInstanceAutomatedBackups",
        "rds:DescribeDBSubnetGroups",
        "rds:DescribeGlobalClusters",
        "rds:DescribePendingMaintenanceActions",
        "rds:DescribeDBParameterGroups",
        "rds:DescribeDBClusterBacktracks",
        "rds:DescribeDBProxyTargets",
        "rds:DescribeDBInstances",
        "rds:DescribeDBProxies",
        "rds:DescribeDBParameters",
        "rds:DescribeDBProxyEndpoints",
        "rds:DescribeDBClusterSnapshotAttributes",
        "rds:DescribeDBClusterParameters",
        "rds:DescribeEventSubscriptions",
        "rds:DescribeDBSnapshots",
        "rds:DescribeDBLogFiles",
        "rds:DescribeDBSecurityGroups",
        "rds:DescribeDBSnapshotAttributes",
        "rds:DescribeReservedDBInstances",
        "rds:DescribeValidDBInstanceModifications",
        "rds:DescribeDBClusterSnapshots",
        "rds:DescribeOptionGroupOptions",
        "rds:DescribeDBClusterEndpoints",
        "rds:DescribeDBClusters",
        "rds:DescribeOptionGroups",
        "rds:DescribeDBClusterParameterGroups"
      ],
      "Resource": [
        "arn:aws:rds:*:${local.account_id}:ri:*",
        "arn:aws:rds:*:${local.account_id}:og:*",
        "arn:aws:rds:*:${local.account_id}:cluster-endpoint:*",
        "arn:aws:rds:*:${local.account_id}:pg:*",
        "arn:aws:rds:*:${local.account_id}:db-proxy:*",
        "arn:aws:rds:*:${local.account_id}:cluster:*",
        "arn:aws:rds:*:${local.account_id}:snapshot:*",
        "arn:aws:rds:*:${local.account_id}:cluster-snapshot:*",
        "arn:aws:rds:*:${local.account_id}:db:*",
        "arn:aws:rds:*:${local.account_id}:es:*",
        "arn:aws:rds:*:${local.account_id}:cluster-pg:*",
        "arn:aws:rds::${local.account_id}:global-cluster:*",
        "arn:aws:rds:*:${local.account_id}:subgrp:*",
        "arn:aws:rds:*:${local.account_id}:secgrp:*",
        "arn:aws:rds:*:${local.account_id}:target-group:*",
        "arn:aws:rds:*:${local.account_id}:db-proxy-endpoint:*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "rds:DescribeDBEngineVersions",
        "rds:DescribeExportTasks",
        "rds:DescribeEngineDefaultParameters",
        "rds:DescribeCustomAvailabilityZones",
        "rds:DescribeReservedDBInstancesOfferings",
        "rds:DescribeOrderableDBInstanceOptions",
        "rds:DescribeEngineDefaultClusterParameters",
        "rds:DescribeSourceRegions",
        "rds:DescribeInstallationMedia",
        "rds:DescribeCertificates",
        "rds:DescribeEventCategories",
        "rds:DescribeAccountAttributes",
        "rds:DescribeEvents"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameter",
        "ssm:GetParametersByPath"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "ec2-instance-role-attach" {
  role       = aws_iam_role.ec2-instance-role.name
  policy_arn = aws_iam_policy.ec2-instance-role-policy.arn
}

resource "aws_iam_instance_profile" "instance-profile" {
  name = join("-", [local.project, "ec2-instance-iam-profile"])
  role = aws_iam_role.ec2-instance-role.name

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.aws_tags, {
      Project = local.project
  })

}