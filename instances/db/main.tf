resource "aws_instance" "mysql-a" {
  ami                    = "ami-03553f266eaffafec"
  instance_type          = "t2.nano"
  subnet_id              = var.subnet_id_private_db_a
  key_name               = "amazon-key"
  vpc_security_group_ids = [var.sec_group_id_allow_vpc_traffic]

  tags = {
    Name     = "mysql-a"
    provider = var.tag_provider
    AZ       = "us-east-2a"
  }
}

