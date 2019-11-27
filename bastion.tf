//Bastion
resource "aws_instance" "bastion" {
  ami                    = var.default_ami
  instance_type          = "t2.nano"
  subnet_id              = element(aws_subnet.public.*.id, 0)
  key_name               = var.access_key
  vpc_security_group_ids = [aws_security_group.allow-ssh.id, aws_security_group.allow-vpc-traffic.id]

  tags = merge(
    var.common_tags,
    map(
      "Name", "bastion",
      "AZ", "us-east-2a"
    )
  )
}

resource "aws_eip" "bastion_eip" {
  instance = aws_instance.bastion.id
  vpc      = true

  tags = merge(
    var.common_tags,
    map(
      "Name", "bastion ip",
      "AZ", "us-east-2a"
    )
  )
}
