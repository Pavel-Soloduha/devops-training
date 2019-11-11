output "sec_group_id_allow_vpc_traffic" {
  value = aws_security_group.allow-vpc-traffic.id
}

output "sec_group_id_allow_ssh" {
  value = aws_security_group.allow-ssh.id
}

output "sec_group_id_allow_inboud" {
  value = aws_security_group.allow-inbound.id
}
