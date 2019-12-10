data "aws_availability_zones" "zones" {}

resource "aws_instance" "backend" {
  count                  = var.backend_subnets_count
  ami                    = var.default_ami
  instance_type          = "t2.micro"
  subnet_id              = element(var.subnet_ids, count.index)
  key_name               = var.access_key
  vpc_security_group_ids = [var.sec_groups_id]

  tags = merge(
    var.common_tags,
    map(
      "Name", "backend",
      "coherent:environment", var.env_tag,
      "AZ", element(data.aws_availability_zones.zones.names, count.index)
    )
  )
}

//resource "aws_lb_target_group" "alb-be-target" {
//  name        = "alb-be-target"
//  port        = 8080
//  protocol    = "HTTP"
//  vpc_id      = var.vpc_id
//  target_type = "instance"
//
//  health_check {
//    enabled  = true
//    interval = 10
//    path     = "/tags"
//  }
//}
//resource "aws_lb_target_group_attachment" "alb-be-attachment" {
//  count            = local.backend_subnet_count
//  target_group_arn = aws_lb_target_group.alb-be-target.arn
//  target_id        = element(aws_instance.backend.*.id, count.index)
//}