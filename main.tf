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
