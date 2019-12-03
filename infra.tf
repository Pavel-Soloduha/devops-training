resource "aws_instance" "jenkins" {
  ami =  var.default_ami
  instance_type = "t3.small"
  subnet_id = aws_subnet.public.*.id[0]
  key_name = var.access_key
  vpc_security_group_ids = [aws_security_group.allow-vpc-traffic.id, aws_security_group.allow-inbound.id]

  tags = merge(
  var.common_tags,
  map(
  "Name", "jenkins",
  "AZ", element(data.aws_availability_zones.zones.names, 0)
  )
  )
}

//resource "aws_instance" "sonar-qube" {
//  ami =  var.default_ami
//  instance_type = "c5.xlarge"
//  subnet_id = aws_subnet.public.*.id[0]
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

resource "aws_instance" "gitlab" {
  ami =  var.default_ami
  instance_type = "t3a.large"
  subnet_id = aws_subnet.public.*.id[0]
  key_name = var.access_key
  vpc_security_group_ids = [aws_security_group.allow-vpc-traffic.id, aws_security_group.allow-inbound.id]

  tags = merge(
  var.common_tags,
  map(
  "Name", "gitlab",
  "AZ", element(data.aws_availability_zones.zones.names, 0)
  )
  )
}

resource "aws_instance" "gitlab-runner" {
  ami =  var.default_ami
  instance_type = "m3.medium"
  subnet_id = aws_subnet.public.*.id[0]
  key_name = var.access_key
  vpc_security_group_ids = [aws_security_group.allow-vpc-traffic.id, aws_security_group.allow-inbound.id]

  tags = merge(
  var.common_tags,
  map(
  "Name", "gitlab-runner",
  "AZ", element(data.aws_availability_zones.zones.names, 0)
  )
  )
}

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
