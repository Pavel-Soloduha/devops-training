variable "region" {
  default = "us-east-2"
}

variable "tag_provider" {
  default = "terraform"
}

variable "cidr" {
  type = "map"
  default = {
    "vpc"            = "10.0.0.0/24"
    "subnet-pub-a"   = "10.0.0.0/27"
    "subnet-pr-db-a" = "10.0.0.32/27"
    "subnet-pr-bk-a" = "10.0.0.64/27"
  }
}

variable "AZ" {
  type = "map"
  default = {
    "A" = "us-east-2a"
    "B" = "us-east-2b"
  }
}
