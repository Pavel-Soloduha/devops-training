resource "aws_subnet" "public_a" {
  vpc_id            = data.aws_vpc.vpc_data.id
  cidr_block        = "10.0.0.0/27"
  availability_zone = "us-east-2a"

  tags = {
    Name     = "Public-A"
    provider = var.tag_provider
    AZ       = "us-east-2a"
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = data.aws_vpc.vpc_data.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name     = "PublicRT"
    provider = var.tag_provider
    AZ       = "us-east-2a"
  }
}

resource "aws_route_table_association" "public-rt-route-a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_internet_gateway" "gw" {
  vpc_id = data.aws_vpc.vpc_data.id

  tags = {
    Name     = "gateway"
    provider = var.tag_provider
  }
}

resource "aws_instance" "nginx_a" {
  ami                    = "ami-0d03add87774b12c5"
  instance_type          = "t2.nano"
  subnet_id              = aws_subnet.public_a.id
  key_name               = "amazon-key"
  vpc_security_group_ids = [aws_security_group.allow-vpc-traffic.id, aws_security_group.allow-inbound.id]
  user_data              = <<EOF
                          #!/bin/bash
                          apt update && apt install -y nginx
                          EOF

  tags = {
    Name     = "nginx-a"
    provider = var.tag_provider
    AZ       = "use-east-2a"
  }
}

resource "aws_eip" "nginx_eip_a" {
  instance = aws_instance.nginx_a.id
  vpc      = true

  tags = {
    Name     = "Nginx ip a"
    provider = var.tag_provider
    AZ       = "us-east-2a"
  }
}
