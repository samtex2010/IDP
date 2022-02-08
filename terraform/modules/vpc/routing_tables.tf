resource "aws_route_table" "route_table" {
  for_each = var.subnets

  vpc_id = aws_vpc.main.id

  tags = merge(
    var.aws_tags, {
      Project = local.project
      Name    = "${local.project}-${each.key}-RT"
  })
}

resource "aws_route_table_association" "subnet_rt_association" {
  for_each = var.subnets

  subnet_id      = aws_subnet.subnet[each.key].id
  route_table_id = aws_route_table.route_table[each.key].id
}

resource "aws_route" "igw_default_route" {
  for_each = local.public_subnets

  route_table_id         = aws_route_table.route_table[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route" "nat_default_route" {
  for_each = local.private_subnets

  route_table_id         = aws_route_table.route_table[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}