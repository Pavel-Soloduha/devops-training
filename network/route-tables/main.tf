//somehow I cannot get to default_route_table of newly created vpc

//data "aws_route_tables" "rts" {
//  vpc_id = var.vpc_id
//}
//
////MainRT
//resource "aws_default_route_table" "default_rt" {
//  default_route_table_id = data.aws_route_tables.rts.ids[0]
//
//  tags = {
//    Name     = "MainRT"
//    provider = var.tag_provider
//    AZ       = "us-east-2a"
//  }
//}

//PrivateRT
resource "aws_route_table" "private_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = var.nat_id
  }

  tags = {
    Name     = "PrivateRT"
    provider = var.tag_provider
    AZ       = "us-east-2a"
  }
}

resource "aws_route_table_association" "private_rt_route_pb_a" {
  subnet_id      = var.subnet_id_private_backend_a
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private-rt-route-pdb-a" {
  subnet_id      = var.subnet_id_private_db_a
  route_table_id = aws_route_table.private_rt.id
}

//PublicRT
resource "aws_route_table" "public-rt" {
  vpc_id = var.vpc_id

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
  subnet_id      = var.subnet_id_public_a
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_internet_gateway" "gw" {
  vpc_id = var.vpc_id

  tags = {
    Name     = "gateway"
    provider = var.tag_provider
  }
}
