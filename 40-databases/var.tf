variable "project" {
  default = "Roboshop"
}
variable "environment" {
  default = "dev"
}
variable "frontend_sg_name" {
  default = "frontend"
}
variable "frontend_sg_discription" {
  default = "created sg for fronted instance"
}

variable "sg_tags"{
  type = map(string)
  default = {}
}
variable "bastion_sg_name" {
  default = "bastion"
}
variable "bastion_sg_discription" {
  default = "created sg for bastion instance"
}
variable "zone_name" {
  default = "gurulabs.xyz"
}