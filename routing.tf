data "aws_route53_zone" "test_zone" {
  zone_id = "Z3W2C0CZ94DL4Z"
}

//resource "aws_route53_record" "route53" {
//  zone_id = data.aws_route53_zone.test_zone.id
//  name    = "*.terraform.solodukha.test.coherentprojects.net"
//  type    = "CNAME"
//  ttl     = "60"
//  records = [aws_lb.alb.dns_name]
//}

resource aws_lb "alb" {
  name               = "alb-solodukha"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow-inbound.id, aws_security_group.allow-vpc-traffic.id]
  subnets            = aws_subnet.public.*.id
}

//listener
resource "aws_lb_listener" "alb-default-listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:242906888793:certificate/f2e8b0e6-aa7a-48be-bedb-945df54a55f2"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "ALB is working"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener" "alb-redirect-listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
