# Configure the AWS Provider
provider "aws" {
  version = "~> 2.0"
  region  = var.region
}

# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr["vpc"]

  tags = {
    Name     = "vpc"
    provider = var.tag-provider
  }
}

# Create subnets
resource "aws_subnet" "private-db-a" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = var.cidr["subnet-pr-db-a"]
  availability_zone = var.AZ["A"]

  tags = {
    Name     = "PrivateDB-A"
    provider = var.tag-provider
    AZ       = var.AZ["A"]
  }
}

resource "aws_subnet" "private-backend-a" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = var.cidr["subnet-pr-bk-a"]
  availability_zone = var.AZ["A"]

  tags = {
    Name     = "PrivateBackend-A"
    provider = var.tag-provider
    AZ       = var.AZ["A"]
  }
}

resource "aws_subnet" "public-a" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = var.cidr["subnet-pub-a"]
  availability_zone = var.AZ["A"]

  tags = {
    Name     = "Public-A"
    provider = var.tag-provider
    AZ       = var.AZ["A"]
  }
}

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
resource "aws_route_table_association" "private-rt-route-a" {
  depends_on     = ["aws_route_table.private-rt"]
  subnet_id      = "${aws_subnet.private-backend-a.id}"
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

resource "aws_instance" "NAT" {

  ami           = "ami-21f6dc44"
  instance_type = "t2.micro"
  subnet_id     = "${aws_subnet.private-backend-a.id}"

  tags = {
    Name     = "NAT"
    provider = var.tag-provider
    AZ       = var.AZ["A"]
  }
}

resource "aws_eip" "lb" {
  instance = "${aws_instance.NAT.id}"
  vpc      = true

  tags = {
    Name     = "NAT ip"
    provider = var.tag-provider
    AZ       = var.AZ["A"]
  }
}


//PublicRT
//need Internet gateway
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

# Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name     = "gateway"
    provider = var.tag-provider
  }
}
