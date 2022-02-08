output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnets" {
  value = { for k, v in aws_subnet.subnet : k => v.id }
}

output "sgs" {
  value = { for k, v in aws_security_group.sg : k => v.id }
}

output "rt" {
  value = { for k, v in aws_route_table.route_table : k => v.id }
}