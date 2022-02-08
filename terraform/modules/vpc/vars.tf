variable "vpc_network" {
  default = "10.10.0.0/16"
}

variable "project" {
  description = "Project tag."
}

variable "aws_tags" {
  type    = map(any)
  default = {}
}

variable "subnets" {
  default = {
    "PUBLIC" = {
      cidr = "10.10.10.0/24"
      az   = "us-east-1a"
      nat  = false
    }
    "PRIVATE" = {
      cidr = "10.10.20.0/24"
      az   = "us-east-1b"
      nat  = true
    }
    "PRIVATE2" = {
      cidr = "10.10.30.0/24"
      az   = "us-east-1a"
      nat  = true
    }
  }
}

variable "sg" {
  default = {
    "PUBLIC" = {
      "ingress_rules" = {
        "ssh" = {
          from_port = 22
          to_port   = 22
          protocol  = "tcp"
          cidr_blocks = [
            "31.202.99.205/32"
          ]
        }
        "http" = {
          from_port = 80
          to_port   = 80
          protocol  = "tcp"
          cidr_blocks = [
            "31.202.99.205/32"
          ]
        }
        "http_8080" = {
          from_port = 8080
          to_port   = 8080
          protocol  = "tcp"
          cidr_blocks = [
            "31.202.99.205/32"
          ]
        }
        "icmp" = {
          from_port = 8
          to_port   = -1
          protocol  = "icmp"
          cidr_blocks = [
            "31.202.99.205/32"
          ]
        }
      }
    }
    "PRIVATE" = {
      "ingress_rules" = {}
    }
  }
}

variable "subnets_az" {
  default = ""
}

data "aws_availability_zones" "azs" {
  state = "available"
}

locals {
  project      = var.project
  az_primary   = var.subnets_az == "" ? data.aws_availability_zones.azs.names[0] : var.subnets_az
  az_secondary = data.aws_availability_zones.azs.names[index(data.aws_availability_zones.azs.names, var.subnets_az == "" ? data.aws_availability_zones.azs.names[0] : var.subnets_az) + 1]
  public_subnets = {
    for key, value in var.subnets : key => {
      cidr = value.cidr
      az   = value.az
    }
    if !value.nat
  }
  public_subnets_names = [
    for key, value in var.subnets : key
    if !value.nat
  ]
  private_subnets = {
    for key, value in var.subnets : key => {
      cidr = value.cidr
      az   = value.az
    }
    if value.nat
  }
  private_subnets_names = [
    for key, value in var.subnets : key
    if value.nat
  ]
}