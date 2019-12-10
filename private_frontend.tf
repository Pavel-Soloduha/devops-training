resource "aws_subnet" "private_frontend" {
  count  = var.frontend_subnets_count
  vpc_id = data.aws_vpc.vpc_data.id
  cidr_block = cidrsubnet(
    signum(length(var.cidr)) == 1 ? var.cidr : data.aws_vpc.vpc_data.cidr_block,
    ceil(log(var.subnets_count, 2)),
    count.index + var.infra_subnets_count + var.backend_subnets_count
  )
  availability_zone       = element(data.aws_availability_zones.zones.names, count.index)
  map_public_ip_on_launch = false

  tags = merge(
    var.common_tags,
    map(
      "Name", "PrivateFrontend",
      "AZ", element(data.aws_availability_zones.zones.names, count.index)
    )
  )
}

resource "aws_route_table_association" "private_rt_route_pf" {
  count          = var.frontend_subnets_count
  subnet_id      = element(aws_subnet.private_frontend.*.id, count.index)
  route_table_id = element(aws_route_table.private_rt.*.id, count.index)
}
