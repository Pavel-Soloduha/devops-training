resource "aws_instance" "nat" {
  count                  = local.public_subnet_count
  ami                    = "ami-00a9d4a05375b2763"
  instance_type          = "t2.nano"
  subnet_id              = element(aws_subnet.public.*.id, count.index)
  key_name               = var.access_key
  vpc_security_group_ids = [aws_security_group.allow-inbound.id, aws_security_group.allow-vpc-traffic.id]
  source_dest_check      = "false"

  tags = merge(
    var.common_tags,
    map(
      "Name", "NAT",
      "AZ", element(data.aws_availability_zones.zones.names, count.index)
    )
  )
}
