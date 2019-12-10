data "aws_route53_zone" "test_zone" {
  zone_id = "Z3W2C0CZ94DL4Z"
}

resource "aws_route53_record" "route53-fe" {
  zone_id = data.aws_route53_zone.test_zone.id
  name    = "terraform.solodukha.test.coherentprojects.net"
  type    = "CNAME"
  ttl     = "60"
  records = [aws_lb.alb_fe.dns_name]
}

resource "aws_route53_record" "route53-be" {
  zone_id = data.aws_route53_zone.test_zone.id
  name    = "back.terraform.solodukha.test.coherentprojects.net"
  type    = "CNAME"
  ttl     = "60"
  records = [aws_lb.alb_be.dns_name]
}

resource aws_lb "alb_fe" {
  name               = "alb-fe-solodukha"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow-inbound.id, aws_security_group.allow-vpc-traffic.id]
  subnets            = aws_subnet.public.*.id
}

//listener
resource "aws_lb_listener" "alb-fe-listener" {
  load_balancer_arn = aws_lb.alb_fe.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:242906888793:certificate/f2e8b0e6-aa7a-48be-bedb-945df54a55f2"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-fe-target.arn
  }
}

resource "aws_lb_target_group" "alb-fe-target" {
  name        = "alb-fe-target"
  port        = 4100
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "instance"

  health_check {
    enabled  = true
    path     = "/"
    interval = 10
  }
}

resource "aws_lb_target_group_attachment" "alb-fe-attachment" {
  count            = local.frontend_subnet_count
  target_group_arn = aws_lb_target_group.alb-fe-target.arn
  target_id        = element(aws_instance.frontend.*.id, count.index)
}

resource aws_lb "alb_be" {
  name               = "alb-be-solodukha"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow-inbound.id, aws_security_group.allow-vpc-traffic.id]
  subnets            = aws_subnet.public.*.id
}

resource "aws_lb_listener" "alb-be-listener" {
  load_balancer_arn = aws_lb.alb_be.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:242906888793:certificate/f2e8b0e6-aa7a-48be-bedb-945df54a55f2"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-be-target.arn
  }
}

resource "aws_lb_target_group" "alb-be-target" {
  name        = "alb-be-target"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "instance"

  health_check {
    enabled  = true
    interval = 10
    path     = "/tags"
  }
}

resource "aws_lb_target_group_attachment" "alb-be-attachment" {
  count            = local.backend_subnet_count
  target_group_arn = aws_lb_target_group.alb-be-target.arn
  target_id        = element(aws_instance.backend.*.id, count.index)
}

resource aws_lb "nlb_db" {
  name               = "nlb-db-solodukha"
  internal           = true
  load_balancer_type = "network"
  subnets            = aws_subnet.private_db.*.id
}

resource "aws_lb_listener" "nlb-db-listener" {
  load_balancer_arn = aws_lb.nlb_db.arn
  port              = 3306
  protocol          = "TCP_UDP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb-db-target.arn
  }
}

resource "aws_lb_target_group" "nlb-db-target" {
  name        = "nlb-db-target"
  port        = 3306
  protocol    = "TCP_UDP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "instance"

  health_check {
    enabled  = true
    interval = 10
    protocol = "TCP"
  }
}

resource "aws_lb_target_group_attachment" "nlb-db-target-attachment" {
  count            = local.private_subnet_count
  target_group_arn = aws_lb_target_group.nlb-db-target.arn
  target_id        = element(aws_instance.mysql.*.id, count.index)
  port             = 3306
}
