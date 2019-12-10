# Configure the AWS Provider
provider "aws" {
  version = "~> 2.0"
  region  = var.region
}

# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr

  tags = merge(
    var.common_tags,
    map(
      "Name", "vpc-solodukha"
    )
  )
}

data "aws_vpc" "vpc_data" {
  id = aws_vpc.vpc.id
}

data "aws_availability_zones" "zones" {
}

resource "aws_route_table" "public_rt" {
  count  = var.aval_zones_count
  vpc_id = data.aws_vpc.vpc_data.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = merge(
    var.common_tags,
    map(
      "Name", "PublicRT",
      "AZ", element(data.aws_availability_zones.zones.names, count.index)
    )
  )
}

resource "aws_route_table" "private_rt" {
  count  = var.aval_zones_count
  vpc_id = data.aws_vpc.vpc_data.id

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = element(aws_instance.nat.*.id, count.index)
  }

  tags = merge(
    var.common_tags,
    map(
      "Name", "PrivateRT",
      "AZ", element(data.aws_availability_zones.zones.names, count.index)
    )
  )
}
