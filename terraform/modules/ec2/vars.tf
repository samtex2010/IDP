variable "project" {
  description = "Project tag."
}

variable "aws_tags" {
  type    = map(any)
  default = {}
}

variable "instance_name_sufix" {
  description = "Instance name suffix"
}

variable "public_ip" {
  description = "public ip association"
  default     = true
}

variable "eip_enable" {
  default = false
}

variable "sg_enable" {
  default = true
}

variable "ec2_sgs_from_vpc" {
  default = []
}

variable "eip_from_vpc" {
  default = false
}

variable "eip_from_vpc_id" {
  default = ""
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in."
}

variable "ssh_key" {
  description = "The key name of the Key Pair to use for the instance."
}

variable "source_dest_check" {
  default = true
}

variable "user_data" {
  default = ""
}

variable "ingress_rules" {
  default = {
    22 = {
      port     = 22
      protocol = "tcp"
      cidr_blocks = [
        "10.10.0.0/16"
      ]
    }
    80 = {
      port     = 80
      protocol = "tcp"
      cidr_blocks = [
        "10.10.0.0/16"
      ]
    }
  }
}

variable "iam_instance_profile" {}

variable "instance_type" {
  description = "The type of instance to start."
  default     = "t4g.micro"
}

variable "disk_size" {
  description = "The size of the root volume in gigabytes."
  default     = 30
}

variable "host_net_numb" {
  default = "10"
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name = "name"

    values = [
      "amzn2-ami-hvm-*-arm64-gp2"
    ]
  }

  filter {
    name = "owner-alias"

    values = [
      "amazon",
    ]
  }
}

variable "aws_ami" {
  default = ""
}

variable "ebs_optimized" {
  default = null
}

data "aws_subnet" "public" {
  id = local.subnet_id
}

locals {
  vpc_id        = data.aws_subnet.public.vpc_id
  cidr_block    = data.aws_subnet.public.cidr_block
  project       = var.project
  ami_id        = var.aws_ami == "" ? data.aws_ami.amazon_linux.id : var.aws_ami
  disk_size     = var.disk_size
  subnet_id     = var.subnet_id
  ssh_key       = var.ssh_key
  instance_type = var.instance_type
  instane_name  = "${var.project}-${var.instance_name_sufix}"
  public_ip     = var.public_ip
}
