module "reverse-proxy" {
  source = "./reverse-proxy"

  sec_group_id_allow_inbound     = var.sec_group_id_allow_inbound
  sec_group_id_allow_vpc_traffic = var.sec_group_id_allow_vpc_traffic
  subnet_id_public_a             = var.subnet_id_public_a
  tag_provider                   = var.tag_provider
}