terraform {
  required_providers {
    local = "~> 2.0"
    aws   = "~> 3.0"
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}