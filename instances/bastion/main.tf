//Bastion
resource "aws_instance" "bastion" {
  ami                    = "ami-0d03add87774b12c5"
  instance_type          = "t2.nano"
  subnet_id              = var.subnet_id_public_a
  key_name               = "amazon-key"
  vpc_security_group_ids = [var.sec_group_id_allow_ssh, var.sec_group_id_allow_vpc_traffic]

  tags = {
    Name     = "bastion"
    provider = var.tag_provider
    AZ       = "us-easy-2a"
  }
}

resource "aws_eip" "bastion-eip-a" {
  instance = aws_instance.bastion.id
  vpc      = true

  tags = {
    Name     = "bastion ip"
    provider = var.tag_provider
    AZ       = "us-east-2a"
  }
}
