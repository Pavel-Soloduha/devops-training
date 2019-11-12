variable "subnet_id_public_a" {
  type        = string
  description = "subnet id"
}

variable "sec_group_id_allow_ssh" {
  type = string
}

variable "sec_group_id_allow_vpc_traffic" {
  type = string
}

variable "tag_provider" {
  type = string
}