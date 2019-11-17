//Bastion
resource "aws_instance" "bastion" {
  ami                    = "ami-0d03add87774b12c5"
  instance_type          = "t2.nano"
  subnet_id              = element(aws_subnet.public.*.id, 0)
  key_name               = "amazon-key"
  vpc_security_group_ids = [aws_security_group.allow-ssh.id, aws_security_group.allow-vpc-traffic.id]

  tags = {
    Name     = "bastion"
    provider = var.tag_provider
    AZ       = "us-easy-2a"
  }
}

resource "aws_eip" "bastion_eip" {
  instance = aws_instance.bastion.id
  vpc      = true

  tags = {
    Name     = "bastion ip"
    provider = var.tag_provider
    AZ       = "us-east-2a"
  }
}
