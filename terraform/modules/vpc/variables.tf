variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "private_subnet" {
  type = string
}

variable "requester_region" {
  type = string
}


variable "vpc_name" {
  type = string
}

variable "ami" {
  type = string
}
