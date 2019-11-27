//data "aws_route_tables" "rts" {
//  vpc_id = data.aws_vpc.vpc_data.id
//}
//
////MainRT
//resource "aws_default_route_table" "default_rt" {
//  default_route_table_id = data.aws_route_tables.rts.id
//
//  tags = merge(
//    var.common_tags,
//    map(
//      "Name", "MainRT"
//    )
//  )
//}
