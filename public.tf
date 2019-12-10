resource "aws_subnet" "public" {
  count  = var.public_subnets_count
  vpc_id = aws_vpc.vpc.id
  cidr_block = cidrsubnet(
    signum(length(var.cidr)) == 1 ? var.cidr : aws_vpc.vpc.cidr_block,
    ceil(log(var.subnets_count, 2)),
    count.index + var.infra_subnets_count + var.backend_subnets_count + var.frontend_subnets_count
  )
  availability_zone       = element(data.aws_availability_zones.zones.names, count.index)
  map_public_ip_on_launch = true

  tags = merge(
    var.common_tags,
    map(
      "Name", "Public",
      "AZ", element(data.aws_availability_zones.zones.names, count.index)
    )
  )
}

resource "aws_route_table_association" "public_rt_route" {
  count          = var.public_subnets_count
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = element(aws_route_table.public_rt.*.id, count.index)
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.common_tags,
    map(
      "Name", "Gateway"
    )
  )
}
