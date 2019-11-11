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

variable "subnet_id_private_db_a" {
  type        = string
  description = "private subnet id"
}

variable "subnet_id_private_backend_a" {
  type        = string
  description = "private backend subnet id"
}

variable "subnet_id_public_a" {
  type        = string
  description = "public subnet id"
}

variable "nat_id" {
  type        = string
  description = "nat instance id"
}
