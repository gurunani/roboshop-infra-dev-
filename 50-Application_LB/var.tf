variable "project" {
  default = "roboshop"
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

variable "sg_tags"{
  type = map(string)
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
variable "zone_name" {
  default = "gurulabs.xyz"
}
variable "zone_id" {
    default = "Z08007301TGLKBZ7OY820"
}
