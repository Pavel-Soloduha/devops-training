output "subnet_id_private_db_a" {
  value = aws_subnet.private_db_a.id
}

output "subnet_id_private_backend_a" {
  value = aws_subnet.private_backend_a.id
}

output "subnet_id_public_a" {
  value = aws_subnet.public_a.id
}
