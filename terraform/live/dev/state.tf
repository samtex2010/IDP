terraform {
  backend "s3" {
    bucket  = "mk-tf-states"
    key     = "idp"
    region  = "us-west-1"
    profile = "samtex"
  }
}