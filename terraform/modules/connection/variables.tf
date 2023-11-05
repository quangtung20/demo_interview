#requester
variable "requester_vpc_id" {
  type = string
}
variable "requester_region" {
  type = string
}
variable "requester_subnet_id" {
  type = string
}
variable "requester_route_table_id" {
  type = string
}

variable "requester_subnet_cidr" {
  type = string
}

#accepter
variable "accpeter_vpc_id" {
  type = string
}
variable "accepter_region" {
  type = string
}
variable "accpeter_subnet_id" {
  type = string
}
variable "accepter_route_table_id" {
  type = string
}
variable "accpeter_subnet_cidr" {
  type = string
}
