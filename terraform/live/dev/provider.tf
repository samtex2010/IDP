terraform {
  required_providers {
    local = "~> 2.0"
    aws   = "~> 3.0"
  }
}

provider "aws" {
  region  = "us-west-1"
  alias   = "samtex"
}

terraform {
  required_version = "= 0.12.29"
}