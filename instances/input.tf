variable "sec_group_id_allow_inbound" {
  type        = string
  description = "sec group id"
}

variable "sec_group_id_allow_vpc_traffic" {
  type        = string
  description = "sec group id"
}

variable "sec_group_id_allow_ssh" {
  type        = string
  description = "sec group id"
}

variable "tag_provider" {
  type        = string
  description = "tag provider"
}

variable "subnet_id_public_a" {
  type        = string
  description = "subnet id"
}

variable "subnet_id_private_backend_a" {
  type        = string
  description = "subnet id"
}

variable "subnet_id_private_db_a" {
  type        = string
  description = "subnet id"
}
