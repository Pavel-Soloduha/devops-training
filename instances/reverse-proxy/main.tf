//Nginx instance
resource "aws_instance" "nginx_a" {

  ami                    = "ami-0d03add87774b12c5"
  instance_type          = "t2.nano"
  subnet_id              = var.subnet_id_public_a
  key_name               = "amazon-key"
  vpc_security_group_ids = [var.sec_group_id_allow_vpc_traffic, var.sec_group_id_allow_inbound]
  user_data              = <<EOF
                          #!/bin/bash
                          apt update && apt install -y nginx
                          EOF

  tags = {
    Name     = "nginx-a"
    provider = var.tag_provider
    AZ       = "use-east-2a"
  }
}

resource "aws_eip" "nginx_eip_a" {
  instance = aws_instance.nginx_a.id
  vpc      = true

  tags = {
    Name     = "Nginx ip a"
    provider = var.tag_provider
    AZ       = "us-east-2a"
  }
}