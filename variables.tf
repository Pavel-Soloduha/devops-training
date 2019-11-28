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

variable "network_layers_count" {
  type    = number
  default = 3
}

variable "common_tags" {
  type = map(string)
  default = {
    "coherent:owner"       = "pavelsolodukha@coherentsolutions.com"
    "coherent:client"      = "Coherent"
    "coherent:project"     = "devops-training"
    "coherent:environment" = "Dev"
    "provider"             = "terraform"
  }
}

variable "default_ami" {
  default = "ami-04763b3055de4860b"
  type    = string
}

variable "access_key" {
  default = "solodukha_sandbox"
}