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

# Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name     = "gateway"
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

resource "aws_subnet" "private-public" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = var.cidr["subnet-pub-a"]
  availability_zone = var.AZ["A"]
  
  tags = {
    Name     = "Public-A"
    provider = var.tag-provider
    AZ       = var.AZ["A"]
  }
}

resource "aws_default_route_table" "default-rt" {
  default_route_table_id = "${aws_vpc.vpc.default_route_table_id}"

  tags = {
    Name     = "MainRT"
    provider = var.tag-provider
    AZ       = var.AZ["A"]
  
  }
}

