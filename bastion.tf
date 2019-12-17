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
      "Name", "Bastion-us-east-2a",
      "app-type", "bastion",
      "AZ", "us-east-2a"
    )
  )
}
