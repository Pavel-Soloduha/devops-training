variable "region" {
  default = "us-east-1"
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

variable "aval_zones_count" {
  type    = number
  default = 2
}

variable "infra_subnets_count" {
  type    = number
  default = 1
}

variable "backend_subnets_count" {
  type    = number
  default = 2
}

variable "frontend_subnets_count" {
  type    = number
  default = 2
}

variable "public_subnets_count" {
  type    = number
  default = 2
}

variable "subnets_count" {
  type = number
  //  default = var.infra_subnets_count + var.backend_subnets_count + var.frontend_subnets_count + var.public_subnets_count
  default = 7
}

variable "common_tags" {
  type = map(string)
  default = {
    "coherent:owner"   = "pavelsolodukha@coherentsolutions.com"
    "coherent:client"  = "Coherent"
    "coherent:project" = "devops-training"
  }
}

variable "default_ami" {
  default = "ami-04763b3055de4860b"
  type    = string
}

variable "access_key" {
  default = "solodukha_sandbox"
}