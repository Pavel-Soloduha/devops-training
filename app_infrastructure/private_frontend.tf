

resource "aws_instance" "frontend" {
  count                  = var.frontend_subnets_count
  ami                    = var.default_ami
  instance_type          = "t2.nano"
  subnet_id              = element(var.pf_subnet_ids, count.index)
  key_name               = var.access_key
  vpc_security_group_ids = [var.vpc_traffic_sec_groups_id]

  tags = merge(
    var.common_tags,
    map(
      "Name", "Frontend-${var.env_tag}-${element(data.aws_availability_zones.zones.names, count.index)}",
      "AZ", element(data.aws_availability_zones.zones.names, count.index)
    )
  )
}

resource "aws_lb_listener_rule" "frontend_lb_rule" {
  listener_arn = var.alb-listener-arn
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.frontend-target.arn
  }
  condition {
    field  = "host-header"
    values = ["front.${var.env_tag}.*"]
  }
}

resource "aws_lb_target_group" "frontend-target" {
  name        = "frontend-target-${var.env_tag}"
  port        = 5000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled  = true
    path     = "/"
    interval = 10
  }
}

resource "aws_lb_target_group_attachment" "alb-fe-attachment" {
  count            = var.frontend_subnets_count
  target_group_arn = aws_lb_target_group.frontend-target.arn
  target_id        = element(aws_instance.frontend.*.id, count.index)
}
