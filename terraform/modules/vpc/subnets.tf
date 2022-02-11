resource "aws_subnet" "subnet" {
  for_each = var.subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  map_public_ip_on_launch = false

  tags = merge(
    var.aws_tags, {
      Project = local.project_idp
      Name    = "${local.project_idp}-${each.key}-SN"
  })
}