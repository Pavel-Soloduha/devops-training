locals {
  backend_subnet_count = var.max_subnet_count == 0 ? length(data.aws_availability_zones.zones.names) : var.max_subnet_count
}

resource "aws_subnet" "private_backend" {
  count  = local.backend_subnet_count
  vpc_id = data.aws_vpc.vpc_data.id
  cidr_block = cidrsubnet(
    signum(length(var.cidr)) == 1 ? var.cidr : data.aws_vpc.vpc_data.cidr_block,
    ceil(log(local.backend_subnet_count * var.network_layers_count, 2)),
    count.index + local.private_subnet_count
  )
  availability_zone       = element(data.aws_availability_zones.zones.names, count.index)
  map_public_ip_on_launch = false

  tags = merge(
    var.common_tags,
    map(
      "Name", "PrivateBackend",
      "AZ", element(data.aws_availability_zones.zones.names, count.index)
    )
  )
}

resource "aws_route_table_association" "private_rt_route_pb" {
  count          = local.backend_subnet_count
  subnet_id      = element(aws_subnet.private_backend.*.id, count.index)
  route_table_id = element(aws_route_table.private_rt.*.id, count.index)
}

resource "aws_instance" "backend" {
  count                  = local.backend_subnet_count
  ami                    = var.default_ami
  instance_type          = "t2.micro"
  subnet_id              = element(aws_subnet.private_backend.*.id, count.index)
  key_name               = var.access_key
  vpc_security_group_ids = [aws_security_group.allow-vpc-traffic.id]

  tags = merge(
    var.common_tags,
    map(
      "Name", "backend",
      "AZ", element(data.aws_availability_zones.zones.names, count.index)
    )
  )
}
