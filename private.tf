locals {
  private_subnet_count = var.max_subnet_count == 0 ? length(data.aws_availability_zones.zones.names) : var.max_subnet_count
}

resource "aws_subnet" "private_db" {
  count  = local.private_subnet_count
  vpc_id = data.aws_vpc.vpc_data.id
  cidr_block = cidrsubnet(
    signum(length(var.cidr)) == 1 ? var.cidr : data.aws_vpc.vpc_data.cidr_block,
    ceil(log(local.private_subnet_count * var.network_layers_count, 2)),
    count.index + local.backend_subnet_count + local.backend_subnet_count
  )
  availability_zone = element(data.aws_availability_zones.zones.names, count.index)

  tags = {
    Name     = "PrivateDB"
    provider = var.tag_provider
    AZ       = element(data.aws_availability_zones.zones.names, count.index)
  }
}

resource "aws_route_table" "private_rt" {
  count  = local.private_subnet_count
  vpc_id = data.aws_vpc.vpc_data.id

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = element(aws_instance.nat.*.id, count.index)
  }

  tags = {
    Name     = "PrivateRT"
    provider = var.tag_provider
    AZ       = element(data.aws_availability_zones.zones.names, count.index)
  }
}

resource "aws_route_table_association" "private_rt_route_db" {
  count          = local.private_subnet_count
  subnet_id      = element(aws_subnet.private_db.*.id, count.index)
  route_table_id = element(aws_route_table.private_rt.*.id, count.index)
}

resource "aws_instance" "mysql" {
  depends_on             = [aws_instance.nat]
  count                  = local.private_subnet_count
  ami                    = "ami-0d03add87774b12c5"
  instance_type          = "t2.nano"
  subnet_id              = element(aws_subnet.private_db.*.id, count.index)
  key_name               = "amazon-key"
  vpc_security_group_ids = [aws_security_group.allow-vpc-traffic.id]
  user_data              = <<EOF
                          #!/bin/bash
                          apt update
                          apt install -y apt-transport-https ca-certificates curl software-properties-common
                          curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
                          add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
                          apt update
                          apt-get install -y docker-ce docker-ce-cli containerd.io
                          EOF

  tags = {
    Name     = "mysql"
    provider = var.tag_provider
    AZ       = element(data.aws_availability_zones.zones.names, count.index)
  }
}

