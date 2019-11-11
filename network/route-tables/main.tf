//MainRT
resource "aws_default_route_table" "default-rt" {
  default_route_table_id = "${aws_vpc.vpc.default_route_table_id}"

  tags = {
    Name     = "MainRT"
    provider = var.tag-provider
    AZ       = var.AZ["A"]
  }
}

//PrivateRT
resource "aws_route_table_association" "private-rt-route-pb-a" {
  depends_on     = ["aws_route_table.private-rt"]
  subnet_id      = "${aws_subnet.private-backend-a.id}"
  route_table_id = "${aws_route_table.private-rt.id}"
}

resource "aws_route_table_association" "private-rt-route-pdb-a" {
  depends_on     = ["aws_route_table.private-rt"]
  subnet_id      = "${aws_subnet.private-db-a.id}"
  route_table_id = "${aws_route_table.private-rt.id}"
}

resource "aws_route_table" "private-rt" {
  depends_on = ["aws_instance.NAT"]
  vpc_id     = "${aws_vpc.vpc.id}"

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = "${aws_instance.NAT.id}"
  }

  tags = {
    Name     = "PrivateRT"
    provider = var.tag-provider
    AZ       = var.AZ["A"]
  }
}

//PublicRT
resource "aws_route_table_association" "public-rt-route-a" {
  depends_on     = ["aws_route_table.public-rt"]
  subnet_id      = "${aws_subnet.public-a.id}"
  route_table_id = "${aws_route_table.public-rt.id}"
}

resource "aws_route_table" "public-rt" {
  depends_on = ["aws_internet_gateway.gw"]
  vpc_id     = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
  tags = {
    Name     = "PublicRT"
    provider = var.tag-provider
    AZ       = var.AZ["A"]
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name     = "gateway"
    provider = var.tag-provider
  }
}