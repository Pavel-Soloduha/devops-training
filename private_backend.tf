resource "aws_subnet" "private_backend_a" {
  vpc_id            = data.aws_vpc.vpc_data.id
  cidr_block        = "10.0.0.64/27"
  availability_zone = "us-east-2a"

  tags = {
    Name     = "PrivateBackend-A"
    provider = var.tag_provider
    AZ       = "us-east-2a"
  }
}

resource "aws_route_table_association" "private_rt_route_pb_a" {
  subnet_id      = aws_subnet.private_backend_a.id
  route_table_id = aws_route_table.private_rt.id
}
