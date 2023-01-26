
variable "name" {
  type        = string
  description = "Load balancer name"
}
variable "subnets" {
  type = list(string)
}


variable "lb_internal" {
}
variable "listener_port" {
}
variable "listener_protocol" {
}
 variable "target_name"{

 }
variable "target_port"{

}
variable "target_protocol"{

}
variable "vpcid"{

}
variable "health_protocol"{

}
variable "ec2_ids"{
    type =list
}
variable "attach_target_port"{

}