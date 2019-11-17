output "sec_group_allow_inbound_id" {
  value = aws_security_group.allow-inbound.id
}

output "sec_group_allow_ssh_id" {
  value = aws_security_group.allow-ssh.id
}

output "sec_group_vpc_traffic_id" {
  value = aws_security_group.allow-vpc-traffic.id
}

output "subnet_public_a" {
  value = aws_subnet.public_a
}