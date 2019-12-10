resource "aws_subnet" "private_infra" {
  vpc_id = data.aws_vpc.vpc_data.id
  cidr_block = cidrsubnet(
    signum(length(var.cidr)) == 1 ? var.cidr : data.aws_vpc.vpc_data.cidr_block,
    ceil(log(local.private_subnet_count * var.network_layers_count, 2)),
    1
  )
  map_public_ip_on_launch = false
  availability_zone       = element(data.aws_availability_zones.zones.names, count.index)

  tags = merge(
    var.common_tags,
    map(
      "Name", "PrivateDB",
      "AZ", element(data.aws_availability_zones.zones.names, count.index)
    )
  )
}

resource "aws_route_table" "private_rt" {
  count  = local.private_subnet_count
  vpc_id = data.aws_vpc.vpc_data.id

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = element(aws_instance.nat.*.id, count.index)
  }

  tags = merge(
    var.common_tags,
    map(
      "Name", "PrivateRT",
      "AZ", element(data.aws_availability_zones.zones.names, count.index)
    )
  )
}

resource "aws_route_table_association" "private_rt_route_db" {
  count          = local.private_subnet_count
  subnet_id      = element(aws_subnet.private_db.*.id, count.index)
  route_table_id = element(aws_route_table.private_rt.*.id, count.index)
}
