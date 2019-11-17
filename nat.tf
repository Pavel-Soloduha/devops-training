resource "aws_instance" "nat" {
  count                  = local.public_subnet_count
  ami                    = "ami-0c1e4eef06f6e6740"
  instance_type          = "t2.nano"
  subnet_id              = element(aws_subnet.public.*.id, count.index)
  key_name               = "amazon-key"
  vpc_security_group_ids = [aws_security_group.allow-inbound.id, aws_security_group.allow-vpc-traffic.id]
  source_dest_check      = "false"
  user_data              = <<EOF
                          #!/bin/bash
                          sysctl -q -w net.ipv4.ip_forward=1 \
                          iptables -t nat -F \
                          iptables -t nat -A POSTROUTING -o eth0 -s "${element(aws_subnet.private_backend.*.id, count.index)}" -j MASQUERADE \
                          iptables -t nat -A POSTROUTING -o eth0 -s "${element(aws_subnet.private_db.*.id, count.index)}" -j MASQUERADE
                          EOF

  tags = {
    Name     = "NAT"
    provider = var.tag_provider
    AZ       = element(data.aws_availability_zones.zones.names, count.index)
  }
}

resource "aws_eip" "nat_eip" {
  count    = local.public_subnet_count
  instance = element(aws_instance.nat.*.id, count.index)
  vpc      = true

  tags = {
    Name     = "nat ip"
    provider = var.tag_provider
    AZ       = element(data.aws_availability_zones.zones.names, count.index)
  }
}
