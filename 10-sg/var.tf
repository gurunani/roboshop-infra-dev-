variable "project" {
  default = "Roboshop"
}
variable "environment" {
  default = "dev"
}
variable "frontend_sg_name" {
  default = "frontend"
}
variable "frontend_sg_description" {
  default = "created sg for frontend instance"
}

variable "sg_tags" {
  type    = map(string)
  default = {}
}
variable "bastion_sg_name" {
  default = "bastion"
}
variable "bastion_sg_description" {
  default = "created sg for bastion instance"
}
variable "backend_alb_sg_name" {
  default = "backend_alb"
}
variable "backend_alb_sg_description" {
  default = "created sg for backend ALB instance"
}
variable "vpn_name" {
  default = "vpn"
}
variable "vpn_description" {
  default = "created sg for vpn instance"
}
variable "mongodb_name" {
  default = "mongodb"
}
variable "mongodb_description" {
  default = "created sg for mongodb instance"
}
variable "mongodb_port_vpn" {
  default = [22, 27017]
}


variable "redis_ports_vpn" {
  default = [22, 6379]
}

variable "mysql_ports_vpn" {
  default = [22, 3306]
}

variable "rabbitmq_ports_vpn" {
  default = [22, 5672]
}