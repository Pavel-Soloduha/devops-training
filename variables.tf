variable "region" {
  default = "us-east-2"
}

variable "tag_provider" {
  default = "terraform"
}

variable "max_subnet_count" {
  default = 2
  type    = number
}

variable "cidr" {
  type    = string
  default = "10.0.0.0/24"
}

variable "AZ" {
  type = "map"
  default = {
    "A" = "us-east-2a"
    "B" = "us-east-2b"
  }
}
