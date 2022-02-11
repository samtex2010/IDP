resource "aws_vpc" "main" {
  cidr_block = var.vpc_network

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.aws_tags, {
      Project = local.project_idp
      Name    = "${local.project_idp}-VPC"
  })
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.aws_tags, {
      Project = local.project_idp
      Name    = "${local.project_idp}-VPC-IGW"
  })
}

resource "aws_eip" "nat_eip" {
  vpc = true

  tags = merge(
    var.aws_tags, {
      Project = local.project_idp
      Name    = "${local.project_idp}-NAT-EIP"
    }
  )
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnet[element(local.public_subnets_names, 0)].id

  tags = merge(
    var.aws_tags, {
      Project = local.project_idp
      Name    = "${local.project_idp}-NAT-GW"
  })
}