# Configure the AWS Provider
provider "aws" {
  version = "~> 2.0"
  region  = var.region
}

# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr["vpc"]

  tags = {
    Name     = "vpc"
    provider = var.tag_provider
  }
}

module "security-groups" {
  source = "./security-groups"

  vpc_id       = aws_vpc.vpc.id
  tag_provider = var.tag_provider
}

module "network" {
  source = "./network"

  vpc_id                         = aws_vpc.vpc.id
  tag_provider                   = var.tag_provider
  aval_zone_count                = 1
  sec_group_id_allow_inbound     = module.security-groups.sec_group_id_allow_inboud
  sec_group_id_allow_vpc_traffic = module.security-groups.sec_group_id_allow_vpc_traffic
}

module "instances" {
  source = "./instances"

  sec_group_id_allow_inbound     = module.security-groups.sec_group_id_allow_inboud
  sec_group_id_allow_vpc_traffic = module.security-groups.sec_group_id_allow_inboud
  subnet_id_public_a             = module.network.subnet_id_public_a
  tag_provider                   = var.tag_provider
}


//
////CMS
//resource "aws_instance" "cms-a" {
//  ami                    = "ami-0d03add87774b12c5"
//  instance_type          = "t2.nano"
//  subnet_id              = "${aws_subnet.private-backend-a.id}"
//  key_name               = "amazon-key"
//  vpc_security_group_ids = ["${aws_security_group.allow-vpc-traffic.id}"]
//  user_data              = <<EOF
//                            #!/bin/bash
//                            apt-get install -y software-properties-common && add-apt-repository -y ppa:ondrej/php && apt-get update && apt-get install -y php7.3
//                            EOF
//
//  tags = {
//    Name     = "CMS-a"
//    provider = var.tag-provider
//    AZ       = var.AZ["A"]
//  }
//}
//
////MySQL
//resource "aws_instance" "mysql-a" {
//  ami                    = "ami-0d03add87774b12c5"
//  instance_type          = "t2.nano"
//  subnet_id              = "${aws_subnet.private-db-a.id}"
//  key_name               = "amazon-key"
//  vpc_security_group_ids = ["${aws_security_group.allow-vpc-traffic.id}"]
//
//  tags = {
//    Name     = "MySQL-a"
//    provider = var.tag-provider
//    AZ       = var.AZ["A"]
//  }
//}
//
////Bastion
//resource "aws_instance" "bastion" {
//  ami                    = "ami-0d03add87774b12c5"
//  instance_type          = "t2.nano"
//  subnet_id              = "${aws_subnet.public-a.id}"
//  key_name               = "amazon-key"
//  vpc_security_group_ids = ["${aws_security_group.allow-ssh.id}", "${aws_security_group.allow-vpc-traffic.id}"]
//
//  tags = {
//    Name     = "Bastion"
//    provider = var.tag-provider
//    AZ       = var.AZ["A"]
//  }
//}
//
//resource "aws_eip" "bastion-eip-a" {
//  depends_on = ["aws_instance.bastion"]
//  instance   = "${aws_instance.bastion.id}"
//  vpc        = true
//
//  tags = {
//    Name     = "Bastion ip"
//    provider = var.tag-provider
//    AZ       = var.AZ["A"]
//  }
//}





