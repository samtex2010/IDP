output "db_endpoint" {
  value = aws_db_instance.pg.endpoint
}

output "db_user" {
  value = aws_db_instance.pg.username
}

output "db_password" {
  value     = aws_db_instance.pg.password
  sensitive = true
}

output "id" {
  value = aws_db_instance.pg.id
}