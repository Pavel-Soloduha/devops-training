# Create subnets
resource "aws_subnet" "private-db-a" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = var.cidr["subnet-pr-db-a"]
  availability_zone = var.AZ["A"]

  tags = {
    Name     = "PrivateDB-A"
    provider = var.tag-provider
    AZ       = var.AZ["A"]
  }
}

resource "aws_subnet" "private-backend-a" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = var.cidr["subnet-pr-bk-a"]
  availability_zone = var.AZ["A"]

  tags = {
    Name     = "PrivateBackend-A"
    provider = var.tag-provider
    AZ       = var.AZ["A"]
  }
}

resource "aws_subnet" "public-a" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = var.cidr["subnet-pub-a"]
  availability_zone = var.AZ["A"]

  tags = {
    Name     = "Public-A"
    provider = var.tag-provider
    AZ       = var.AZ["A"]
  }
}

//MainRT
resource "aws_default_route_table" "default-rt" {
  default_route_table_id = "${aws_vpc.vpc.default_route_table_id}"

  tags = {
    Name     = "MainRT"
    provider = var.tag-provider
    AZ       = var.AZ["A"]
  }
}

//PrivateRT
resource "aws_route_table_association" "private-rt-route-pb-a" {
  depends_on     = ["aws_route_table.private-rt"]
  subnet_id      = "${aws_subnet.private-backend-a.id}"
  route_table_id = "${aws_route_table.private-rt.id}"
}

resource "aws_route_table_association" "private-rt-route-pdb-a" {
  depends_on     = ["aws_route_table.private-rt"]
  subnet_id      = "${aws_subnet.private-db-a.id}"
  route_table_id = "${aws_route_table.private-rt.id}"
}

resource "aws_route_table" "private-rt" {
  depends_on = ["aws_instance.NAT"]
  vpc_id     = "${aws_vpc.vpc.id}"

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = "${aws_instance.NAT.id}"
  }

  tags = {
    Name     = "PrivateRT"
    provider = var.tag-provider
    AZ       = var.AZ["A"]
  }
}



//still need iptables -t nat -A POSTROUTING -s 10.0.0.64/27 -o eth0 -j MASQUERADE
//and sed /etc/systcl.conf to enable ip_forwarding
resource "aws_instance" "NAT" {
  ami                    = "ami-0c1e4eef06f6e6740"
  instance_type          = "t2.nano"
  subnet_id              = "${aws_subnet.public-a.id}"
  key_name               = "amazon-key"
  vpc_security_group_ids = ["${aws_security_group.allow-inbound.id}", "${aws_security_group.allow-vpc-traffic.id}"]
  source_dest_check      = "false"
  user_data              = <<EOF
                          #!/bin/bash
                          sysctl -q -w net.ipv4.ip_forward=1 && iptables -t nat -F && iptables -t nat -A POSTROUTING -o eth0 -s 10.0.0.64/27 -j MASQUERADE && iptables -t nat -A POSTROUTING -o eth0 -s 10.0.0.32/27 -j MASQUERADE
                          EOF

  tags = {
    Name     = "NAT"
    provider = var.tag-provider
    AZ       = var.AZ["A"]
  }
}

resource "aws_eip" "nat-eip-a" {
  instance = "${aws_instance.NAT.id}"
  vpc      = true

  tags = {
    Name     = "NAT ip a"
    provider = var.tag-provider
    AZ       = var.AZ["A"]
  }
}


//PublicRT
//need Internet gateway
resource "aws_route_table_association" "public-rt-route-a" {
  depends_on     = ["aws_route_table.public-rt"]
  subnet_id      = "${aws_subnet.public-a.id}"
  route_table_id = "${aws_route_table.public-rt.id}"
}

resource "aws_route_table" "public-rt" {
  depends_on = ["aws_internet_gateway.gw"]
  vpc_id     = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
  tags = {
    Name     = "PublicRT"
    provider = var.tag-provider
    AZ       = var.AZ["A"]
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name     = "gateway"
    provider = var.tag-provider
  }
}