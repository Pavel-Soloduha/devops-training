locals {
  public_subnet_count = var.max_subnet_count == 0 ? length(data.aws_availability_zones.zones.names) : var.max_subnet_count
}

resource "aws_subnet" "public" {
  count  = local.public_subnet_count
  vpc_id = data.aws_vpc.vpc_data.id
  cidr_block = cidrsubnet(
    signum(length(var.cidr)) == 1 ? var.cidr : data.aws_vpc.vpc_data.cidr_block,
    ceil(log(local.public_subnet_count * 2, 2)),
    count.index
  )
  availability_zone = element(data.aws_availability_zones.zones.names, count.index)

  tags = {
    Name     = "public"
    provider = var.tag_provider
    AZ       = element(data.aws_availability_zones.zones.names, count.index)
  }
}

resource "aws_route_table" "public_rt" {
  count  = local.public_subnet_count
  vpc_id = data.aws_vpc.vpc_data.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name     = "publicRT"
    provider = var.tag_provider
    AZ       = element(data.aws_availability_zones.zones.names, count.index)
  }
}

resource "aws_route_table_association" "public_rt_route" {
  count          = local.public_subnet_count
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = element(aws_route_table.public_rt.*.id, count.index)
}

resource "aws_internet_gateway" "gw" {
  vpc_id = data.aws_vpc.vpc_data.id

  tags = {
    Name     = "gateway"
    provider = var.tag_provider
  }
}

resource "aws_instance" "nginx" {
  count                  = local.public_subnet_count
  ami                    = "ami-0d03add87774b12c5"
  instance_type          = "t2.nano"
  subnet_id              = element(aws_subnet.public.*.id, count.index)
  key_name               = "amazon-key"
  vpc_security_group_ids = [aws_security_group.allow-vpc-traffic.id, aws_security_group.allow-inbound.id]
  user_data              = <<EOF
                          #!/bin/bash
                          apt update && apt install -y nginx
                          EOF

  tags = {
    Name     = "nginx"
    provider = var.tag_provider
    AZ       = element(data.aws_availability_zones.zones.names, count.index)
  }
}

resource "aws_eip" "nginx_eip" {
  count    = local.public_subnet_count
  instance = element(aws_instance.nginx.*.id, count.index)
  vpc      = true

  tags = {
    Name     = "nginx ip"
    provider = var.tag_provider
    AZ       = element(data.aws_availability_zones.zones.names, count.index)
  }
}
