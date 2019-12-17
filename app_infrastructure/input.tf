variable "default_ami" {}

variable "backend_subnets_count" {}
variable "frontend_subnets_count" {}

variable "common_tags" {}

variable "vpc_id" {}

variable "access_key" {}

variable "pb_subnet_ids" {}
variable "pf_subnet_ids" {}

variable "vpc_traffic_sec_groups_id" {}
variable "inbound_sec_groups_id" {}
variable "ssh_sec_groups_id" {}

variable "env_tag" {}

variable "alb-listener-arn" {}

variable "aws_route53_zone_id" {}
variable "aws_lb_dns_name" {}