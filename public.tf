//PublicRT
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
