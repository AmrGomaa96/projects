#subnets
variable "cidr_subnet" {
  type    = map
}


variable "aZ" {
  type = map
  description = "adding az to subnets"
}

variable "vpc_id" {
  
}

variable "egress_cidr" {
  
}

variable "ingress_cider" {
  
}
variable "int_gateway" {

}

variable "nat_gateway"{

}

variable "public_keys" {
  type= list
}
variable "private_keys" {
  type= list
}