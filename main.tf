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

data "aws_vpc" "vpc_data" {
  id = aws_vpc.vpc.id
}

data "aws_availability_zones" "aval_zones" {
}

//module "network" {
//  source = "./network"
//
//  vpc_id                         = aws_vpc.vpc.id
//  tag_provider                   = var.tag_provider
//  aval_zone_count                = 1
//  sec_group_id_allow_inbound     = module.security-groups.sec_group_id_allow_inboud
//  sec_group_id_allow_vpc_traffic = module.security-groups.sec_group_id_allow_vpc_traffic
//}
//
//module "instances" {
//  source = "./instances"
//
//  sec_group_id_allow_inbound     = module.security-groups.sec_group_id_allow_inboud
//  sec_group_id_allow_vpc_traffic = module.security-groups.sec_group_id_allow_vpc_traffic
//  subnet_id_public_a             = module.network.subnet_id_public_a
//  tag_provider                   = var.tag_provider
//  sec_group_id_allow_ssh         = module.security-groups.sec_group_id_allow_ssh
//  subnet_id_private_backend_a    = module.network.subnet_id_private_backend_a
//  subnet_id_private_db_a         = module.network.subnet_id_private_db_a
//}
