# Configure the AWS Provider
provider "aws" {
  version = "~> 2.0"
  region  = var.region
}

# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr

  tags = merge(
    var.common_tags,
    map(
      "Name", "vpc-solodukha"
    )
  )
}

data "aws_availability_zones" "zones" {
}

resource "aws_route_table" "public_rt" {
  count  = var.aval_zones_count
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = merge(
    var.common_tags,
    map(
      "Name", "PublicRT",
      "AZ", element(data.aws_availability_zones.zones.names, count.index)
    )
  )
}

resource "aws_route_table" "private_rt" {
  count  = var.aval_zones_count
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = element(aws_instance.nat.*.id, count.index)
  }

  tags = merge(
    var.common_tags,
    map(
      "Name", "PrivateRT",
      "AZ", element(data.aws_availability_zones.zones.names, count.index)
    )
  )
}

module "application_dev_infrastructure" {
  source = "./app_infrastructure"

  access_key                = var.access_key
  backend_subnets_count     = var.backend_subnets_count
  common_tags               = var.common_tags
  default_ami               = var.default_ami
  vpc_id                    = aws_vpc.vpc.id
  pb_subnet_ids             = [aws_subnet.private_backend.*.id[0], aws_subnet.private_backend.*.id[1]]
  vpc_traffic_sec_groups_id = aws_security_group.allow-vpc-traffic.id
  inbound_sec_groups_id     = aws_security_group.allow-inbound.id
  ssh_sec_groups_id         = aws_security_group.allow-ssh.id
  env_tag                   = "dev"
  alb-listener-arn          = aws_lb_listener.alb-default-listener.arn
  frontend_subnets_count    = var.frontend_subnets_count
  pf_subnet_ids             = [aws_subnet.private_frontend.*.id[0], aws_subnet.private_frontend.*.id[1]]
  aws_lb_dns_name           = aws_lb.alb.dns_name
  aws_route53_zone_id       = data.aws_route53_zone.test_zone.id
}

module "application_prod_infrastructure" {
  source = "./app_infrastructure"

  access_key                = var.access_key
  backend_subnets_count     = var.backend_subnets_count
  common_tags               = var.common_tags
  default_ami               = var.default_ami
  vpc_id                    = aws_vpc.vpc.id
  pb_subnet_ids             = [aws_subnet.private_backend.*.id[0], aws_subnet.private_backend.*.id[1]]
  vpc_traffic_sec_groups_id = aws_security_group.allow-vpc-traffic.id
  inbound_sec_groups_id     = aws_security_group.allow-inbound.id
  ssh_sec_groups_id         = aws_security_group.allow-ssh.id
  env_tag                   = "prod"
  alb-listener-arn          = aws_lb_listener.alb-default-listener.arn
  frontend_subnets_count    = var.frontend_subnets_count
  pf_subnet_ids             = [aws_subnet.private_frontend.*.id[0], aws_subnet.private_frontend.*.id[1]]
  aws_lb_dns_name           = aws_lb.alb.dns_name
  aws_route53_zone_id       = data.aws_route53_zone.test_zone.id
}
