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