resource "aws_instance" "nat" {
  ami                    = "ami-0c1e4eef06f6e6740"
  instance_type          = "t2.nano"
  subnet_id              = var.subnet_id
  key_name               = "amazon-key"
  vpc_security_group_ids = [var.sec_group_id_allow_inbound, var.sec_group_id_allow_vpc_traffic]
  source_dest_check      = "false"
  user_data              = <<EOF
                          #!/bin/bash
                          sysctl -q -w net.ipv4.ip_forward=1 && iptables -t nat -F && iptables -t nat -A POSTROUTING -o eth0 -s 10.0.0.64/27 -j MASQUERADE && iptables -t nat -A POSTROUTING -o eth0 -s 10.0.0.32/27 -j MASQUERADE
                          EOF

  tags = {
    Name     = "NAT"
    provider = var.tag_provider
    AZ       = "us-east-2a"
  }
}

resource "aws_eip" "nat_eip_a" {
  instance = aws_instance.nat.id
  vpc      = true

  tags = {
    Name     = "NAT ip a"
    provider = var.tag_provider
    AZ       = "us-east-2a"
  }
}
