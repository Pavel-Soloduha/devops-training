# Configure the AWS Provider
provider "aws" {
  version = "~> 2.0"
  region  = "us-east-2"
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "vpc"
    provider = "terraform"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "gateway"
    provider = "terraform"
  }
}

# Create subnets
resource "aws_subnet" "main" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.0.32/27"
  availability_zone = "us-east-2a"

  tags = {
    Name = "PrivateDB-A"
    provider = "terraform"
    AZ = "us-east-2a"
  }
}

