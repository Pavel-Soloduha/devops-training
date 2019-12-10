//Security groups
resource "aws_security_group" "allow-ssh" {
  name        = "allow-ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  tags = {
    Name     = "allow-ssh"
    provider = var.tag_provider
  }
}

resource "aws_security_group" "allow-vpc-traffic" {
  name        = "allow-vpc-traffic"
  description = "Allow all inner VPC traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    cidr_blocks = [
    "10.0.0.0/24"]
  }
  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "udp"
    cidr_blocks = [
    "10.0.0.0/24"]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  tags = {
    Name     = "allow-vpc-traffic"
    provider = var.tag_provider
  }
}

resource "aws_security_group" "allow-inbound" {
  name        = "allow-inbound"
  description = "Allow 80/443 inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "udp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "udp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  tags = {
    Name     = "allow-inbound"
    provider = var.tag_provider
  }
}
