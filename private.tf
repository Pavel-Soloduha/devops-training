resource "aws_subnet" "private_db_a" {
  vpc_id            = data.aws_vpc.vpc_data.id
  cidr_block        = "10.0.0.32/27"
  availability_zone = "us-east-2a"

  tags = {
    Name     = "PrivateDB-A"
    provider = var.tag_provider
    AZ       = "us-east-2a"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = data.aws_vpc.vpc_data.id

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = aws_instance.nat.id
  }

  tags = {
    Name     = "PrivateRT"
    provider = var.tag_provider
    AZ       = "us-east-2a"
  }
}

resource "aws_route_table_association" "private-rt-route-pdb-a" {
  subnet_id      = aws_subnet.private_db_a.id
  route_table_id = aws_route_table.private_rt.id
}
