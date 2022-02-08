output "instance_profile" {
  value = module.iam.iam_instance_profile
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_subnets" {
  value = module.vpc.subnets
}

output "vpc_sgs" {
  value = module.vpc.sgs
}

output "vpc_rt" {
  value = module.vpc.rt
}

output "ec2_public_ip" {
  value = module.ec2.ec2_public_ip
}