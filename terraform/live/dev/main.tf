resource "aws_key_pair" "devops-key" {
  key_name   = "devops-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCf1E8loYYDjbKgE96jLWiLlFrG1g093E59LVnItzPAC/65EthjdE4aeT80K/KoKYbI7T9K4DRAAI03WRKi6Mjb28cptvihJimLT3CeVqtn6NGTKuP2Cu738gDobIQOxCk1r4xvdzBIiNRvZsXsFYFUM8qgFxF5asLJa8TFIdjGWJFug/M4ZrQkQhVfFHLf8B04/xPr73GgBs0get4QC9Rk/bUkgD8iz/yOC9LxlZlNpd4/kt7E+0LKjuUaMcwhNQ3pa9I14fraoAIXw+5QqYTZQYTMXdRAMjd5M0yP/U6Gsj4OUh+Qu44GYWGXIoVm9/EN8Jpx6WYL8XMTiFuxs797"

  tags = var.tags
}

module "iam" {
  source   = "../../modules/iam"
  project  = var.project
  aws_tags = var.tags
}

module "vpc" {
  source   = "../../modules/vpc"
  project  = var.project
  aws_tags = var.tags
}

module "ec2" {
  source               = "../../modules/ec2"
  project              = var.project
  aws_tags             = var.tags
  iam_instance_profile = module.iam.iam_instance_profile
  instance_name_sufix  = "EC2"
  subnet_id            = module.vpc.subnets["PUBLIC"]
  ssh_key              = aws_key_pair.devops-key.key_name
  public_ip            = true
  sg_enable            = false
  ebs_optimized        = true
  disk_size            = 50
  instance_type        = "t4g.medium"
  ec2_sgs_from_vpc     = [module.vpc.sgs["PUBLIC"]]
  host_net_numb        = 5
  user_data            = <<EOF
#!/bin/bash
yum install curl vim java-1.8.0-openjdk-headless -y
EOF
}

resource "local_file" "hosts_file" {
  content = templatefile(
    "./hosts.tftpl",
    {
      user    = "ec2-user"
      project = var.project
      server  = module.ec2.ec2_public_ip
    }
  )
  filename = "../../../ansible/${var.project}_hosts"
}

resource "random_password" "rds_password" {
  length      = 16
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
  special     = false
}

module "rds" {
  source = "../../modules/rds"
  private_subnet_ids = [
    module.vpc.subnets["PRIVATE"],
    module.vpc.subnets["PRIVATE2"]
  ]
  project              = var.project
  aws_tags             = var.tags
  db_password          = random_password.rds_password.result
  sg_enable            = false
  rds_sgs_from_vpc     = [module.vpc.sgs["PRIVATE"]]
  storage_encrypted    = true
  deletion_protection  = false
  instance_type        = "db.t3.micro"
  parameter_group_name = "default.postgres13"
  engine_version       = "13.4"
}