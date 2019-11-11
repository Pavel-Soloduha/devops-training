variable "vpc_id" {
  type        = string
  description = "Id of VPC"
}

variable "tag_provider" {
  type        = string
  description = "Name of infrastructure provider"
}

variable "aval_zone_count" {
  type        = number
  description = "Amount of avalability zones work with"
}

variable "subnet_id" {
  type        = string
  description = "subnet id for NAT instance"
}

variable "sec_group_id_allow_inbound" {
  type        = string
  description = "sec group id"
}

variable "sec_group_id_allow_vpc_traffic" {
  type        = string
  description = "sec group id"
}
