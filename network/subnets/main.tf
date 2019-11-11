# Create subnets
resource "aws_subnet" "private_db_a" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.0.32/27"
  availability_zone = "us-east-2a"

  tags = {
    Name     = "PrivateDB-A"
    provider = var.tag_provider
    AZ       = "us-east-2a"
  }
}

resource "aws_subnet" "private_backend_a" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.0.64/27"
  availability_zone = "us-east-2a"

  tags = {
    Name     = "PrivateBackend-A"
    provider = var.tag_provider
    AZ       = "us-east-2a"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.0.0/27"
  availability_zone = "us-east-2a"

  tags = {
    Name     = "Public-A"
    provider = var.tag_provider
    AZ       = "us-east-2a"
  }
}