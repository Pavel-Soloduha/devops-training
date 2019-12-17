data "aws_availability_zones" "zones" {}

resource "aws_instance" "backend" {
  count                  = var.backend_subnets_count
  ami                    = var.default_ami
  instance_type          = "t2.micro"
  subnet_id              = element(var.pb_subnet_ids, count.index)
  key_name               = var.access_key
  vpc_security_group_ids = [var.vpc_traffic_sec_groups_id]

  tags = merge(
    var.common_tags,
    map(
      "Name", "Backend-${var.env_tag}-${element(data.aws_availability_zones.zones.names, count.index)}",
      "coherent:environment", var.env_tag,
      "AZ", element(data.aws_availability_zones.zones.names, count.index)
    )
  )
}

resource "aws_route53_record" "backend-route53" {
  zone_id = var.aws_route53_zone_id
  name    = "back-${var.env_tag}-solodukha.test.coherentprojects.net"
  type    = "CNAME"
  ttl     = "60"
  records = [var.aws_lb_dns_name]
}

resource "aws_lb_listener_rule" "backend_lb_rule" {
  listener_arn = var.alb-listener-arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_target.arn
  }
  condition {
    field  = "host-header"
    values = ["back-${var.env_tag}-solodukha.*"]
  }
}

resource "aws_lb_target_group" "backend_target" {
  name        = "backend-target-${var.env_tag}"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled  = true
    interval = 10
    path     = "/tags"
  }
}

resource "aws_lb_target_group_attachment" "alb-be-attachment" {
  count            = var.backend_subnets_count
  target_group_arn = aws_lb_target_group.backend_target.arn
  target_id        = element(aws_instance.backend.*.id, count.index)
}
