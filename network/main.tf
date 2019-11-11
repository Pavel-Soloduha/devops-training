
module "subnets" {
  source = "./subnets"

  tag_provider    = var.tag_provider
  vpc_id          = var.vpc_id
  aval_zone_count = var.aval_zone_count
}

module "nat" {
  source = "./nat"

  tag_provider                   = var.tag_provider
  vpc_id                         = var.vpc_id
  aval_zone_count                = var.aval_zone_count
  subnet_id                      = module.subnets.subnet_id_private_db_a
  sec_group_id_allow_inbound     = var.sec_group_id_allow_inbound
  sec_group_id_allow_vpc_traffic = var.sec_group_id_allow_vpc_traffic
}

module "route_tables" {
  source = "./route-tables"

  tag_provider    = var.tag_provider
  vpc_id          = var.vpc_id
  aval_zone_count = var.aval_zone_count
}
