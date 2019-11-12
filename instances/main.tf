module "reverse-proxy" {
  source = "./reverse-proxy"

  sec_group_id_allow_inbound     = var.sec_group_id_allow_inbound
  sec_group_id_allow_vpc_traffic = var.sec_group_id_allow_vpc_traffic
  subnet_id_public_a             = var.subnet_id_public_a
  tag_provider                   = var.tag_provider
}

module "bastion" {

  source = "./bastion"

  sec_group_id_allow_vpc_traffic = var.sec_group_id_allow_vpc_traffic
  subnet_id_public_a             = var.subnet_id_public_a
  tag_provider                   = var.tag_provider
  sec_group_id_allow_ssh         = var.sec_group_id_allow_ssh
}

module "backend" {
  source = "./backend"

  sec_group_allow_vpc_traffic = var.sec_group_id_allow_vpc_traffic
  subnet_id_private_backend_a = var.subnet_id_private_backend_a
  tag_provider                = var.tag_provider
}

module "db" {
  source = "./db"

  sec_group_id_allow_vpc_traffic = var.sec_group_id_allow_vpc_traffic
  subnet_id_private_db_a         = var.subnet_id_private_db_a
  tag_provider                   = var.tag_provider
}