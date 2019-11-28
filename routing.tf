data "aws_route53_zone" "test_zone" {
  zone_id = "Z3W2C0CZ94DL4Z"
}

resource "aws_route53_record" "solodukha" {
  zone_id = data.aws_route53_zone.test_zone.zone_id
  name    = "solodukha.${data.aws_route53_zone.test_zone.name}"
  type    = "A"
  ttl     = "300"
  records = [element(aws_instance.frontend.*.private_ip, 0)]
}

//resource "aws_lb" "public_frontend_lb" {
//  count              = local.frontend_subnet_count
//  name               = "public-frontend-lb"
//  internal           = false
//  load_balancer_type = "application"
//  //  security_groups    = [aws_security_group.allow-inbound.id]
//  subnets = [element(aws_subnet.private_frontend.*.id, 0), element(aws_subnet.private_frontend.*.id, 1)]
//
//  tags = merge(
//    var.common_tags,
//    map(
//      "Name", "public",
//      "AZ", element(data.aws_availability_zones.zones.names, count.index)
//    )
//  )
//}
//
//resource "aws_lb_target_group" "lb_target_front" {
//  name     = "lb-target-front"
//  port     = 4100
//  protocol = "HTTP"
//  vpc_id   = aws_vpc.vpc.id
//}
//
//resource "aws_lb_target_group_attachment" "lb_target_attach" {
//  count = local.frontend_subnet_count
//
//  target_group_arn = aws_lb_target_group.lb_target_front.arn
//  target_id        = element(aws_instance.frontend.*.id, count.index)
//  port             = 4100
//}