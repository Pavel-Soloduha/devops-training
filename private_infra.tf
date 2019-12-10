resource "aws_subnet" "private_infra" {
  count                   = var.infra_subnets_count
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, ceil(log(var.subnets_count, 2)), count.index)
  map_public_ip_on_launch = false
  availability_zone       = element(data.aws_availability_zones.zones.names, count.index)

  tags = merge(
    var.common_tags,
    map(
      "Name", "PrivateInfra",
      "AZ", element(data.aws_availability_zones.zones.names, count.index)
    )
  )
}

resource "aws_route_table_association" "private_rt_route_db" {
  count          = var.infra_subnets_count
  subnet_id      = element(aws_subnet.private_infra.*.id, count.index)
  route_table_id = element(aws_route_table.private_rt.*.id, count.index)
}

resource "aws_instance" "jenkins" {
  count                  = var.infra_subnets_count
  ami                    = var.default_ami
  instance_type          = "t3.small"
  subnet_id              = aws_subnet.private_infra.*.id[0]
  key_name               = var.access_key
  vpc_security_group_ids = [aws_security_group.allow-vpc-traffic.id, aws_security_group.allow-inbound.id]

  tags = merge(
    var.common_tags,
    map(
      "Name", "Jenkins-${element(data.aws_availability_zones.zones.names, count.index)}",
      "AZ", element(data.aws_availability_zones.zones.names, count.index)
    )
  )
}

resource "aws_lb_listener_rule" "jenkins_lb_rule" {
  listener_arn = aws_lb_listener.alb-default-listener.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins_target.arn
  }
  condition {
    field  = "host-header"
    values = ["jenkins.*"]
  }
}

resource "aws_lb_target_group" "jenkins_target" {
  name     = "solodukha-jenkins-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  tags = merge(
    var.common_tags
  )

  health_check {
    enabled = true
    timeout = 10
    matcher = "200-499"
  }
}

resource "aws_lb_target_group_attachment" "jenkins_target_attachment" {
  count            = var.infra_subnets_count
  target_group_arn = aws_lb_target_group.jenkins_target.arn
  target_id        = element(aws_instance.jenkins.*.id, count.index)
  port             = 80
}

//resource "aws_instance" "sonar-qube" {
//  ami =  var.default_ami
//  instance_type = "c5.xlarge"
//  subnet_id = aws_subnet.private_infra.*.id[0]
//  key_name = var.access_key
//  vpc_security_group_ids = [aws_security_group.allow-vpc-traffic.id, aws_security_group.allow-inbound.id]
//
//  tags = merge(
//  var.common_tags,
//  map(
//  "Name", "sonar-qube",
//  "AZ", element(data.aws_availability_zones.zones.names, 0)
//  )
//  )
//}

//resource "aws_instance" "gitlab" {
//  ami                    = var.default_ami
//  instance_type          = "t3a.large"
//  subnet_id              = aws_subnet.private_infra.*.id[0]
//  key_name               = var.access_key
//  vpc_security_group_ids = [aws_security_group.allow-vpc-traffic.id, aws_security_group.allow-inbound.id]
//
//  tags = merge(
//    var.common_tags,
//    map(
//      "Name", "gitlab",
//      "AZ", element(data.aws_availability_zones.zones.names, 0)
//    )
//  )
//}
//
//resource "aws_instance" "gitlab-runner" {
//  ami                    = var.default_ami
//  instance_type          = "m3.medium"
//  subnet_id              = aws_subnet.private_infra.*.id[0]
//  key_name               = var.access_key
//  vpc_security_group_ids = [aws_security_group.allow-vpc-traffic.id, aws_security_group.allow-inbound.id]
//
//  tags = merge(
//    var.common_tags,
//    map(
//      "Name", "gitlab-runner",
//      "AZ", element(data.aws_availability_zones.zones.names, 0)
//    )
//  )
//}

//resource "aws_instance" "nexus" {
//  ami =  var.default_ami
//  instance_type = "c5.xlarge"
//  subnet_id = aws_subnet.public.*.id[0]
//  key_name = var.access_key
//  vpc_security_group_ids = [aws_security_group.allow-vpc-traffic.id, aws_security_group.allow-inbound.id]
//
//  tags = merge(
//  var.common_tags,
//  map(
//  "Name", "nexus",
//  "AZ", element(data.aws_availability_zones.zones.names, 0)
//  )
//  )
//}
