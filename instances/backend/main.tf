resource "aws_instance" "cms-a" {
  ami                    = "ami-0d03add87774b12c5"
  instance_type          = "t2.nano"
  subnet_id              = var.subnet_id_private_backend_a
  key_name               = "amazon-key"
  vpc_security_group_ids = [var.sec_group_allow_vpc_traffic]

  tags = {
    Name     = "cms-a"
    provider = var.tag_provider
    AZ       = "us-east-2a"
  }
}
