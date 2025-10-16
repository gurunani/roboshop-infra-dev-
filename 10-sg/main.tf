module "frontend" {
  source = "git::https://github.com/gurunani/terraform-aws-securitygroup.git?ref=main"
  project = var.project
  environment = var.environment
  sg_name = var.frontend_sg_name
  sg_description = var.frontend_sg_description
  vpc_id = local.vpc_id
}

module "bastion" {
  source = "git::https://github.com/gurunani/terraform-aws-securitygroup.git?ref=main"
  project = var.project
  environment = var.environment
  sg_name = var.bastion_sg_name
  sg_description = var.bastion_sg_description
  vpc_id = local.vpc_id
}
module "backend_alb" {
  source = "git::https://github.com/gurunani/terraform-aws-securitygroup.git?ref=main"
  project = var.project
  environment = var.environment
  sg_name = var.backend_alb_sg_name
  sg_description = var.backend_alb_sg_description
  vpc_id = local.vpc_id
}

module "vpn" {
  source = "git::https://github.com/gurunani/terraform-aws-securitygroup.git?ref=main"
  project = var.project
  environment = var.environment
  sg_name = var.vpn_name
  sg_description = var.vpn_description
  vpc_id = local.vpc_id
}
module "mongodb" {
  source = "git::https://github.com/gurunani/terraform-aws-securitygroup.git?ref=main"
  project = var.project
  environment = var.environment
  sg_name = var.mongodb_name
  sg_description = var.mongodb_description
  vpc_id = local.vpc_id
}

#bastion accpting connections from my laptop
resource "aws_security_group_rule" "mongodb_vpn_ssh" {
  count = length(var.mongodb_port_vpn)
  type              = "ingress"
  from_port         = var.mongodb_port_vpn[count.index]
  to_port           = var.mongodb_port_vpn[count.index]
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.mongodb.sg_id
}

#bastion accpting connections from my laptop
resource "aws_security_group_rule" "backend_alb_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.backend_alb.sg_id
}

#VPN ports 22, 443, 1194, 943
# resource "aws_security_group_rule" "vpn_ssh" {
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   cidr_blocks = ["0.0.0.0/0"]
#   security_group_id = module.vpn.sg_id
# }

# resource "aws_security_group_rule" "vpn_https" {
#   type              = "ingress"
#   from_port         = 443
#   to_port           = 443
#   protocol          = "tcp"
#   cidr_blocks = ["0.0.0.0/0"]
#   security_group_id = module.vpn.sg_id
# }

# resource "aws_security_group_rule" "vpn_1194" {
#   type              = "ingress"
#   from_port         = 1194
#   to_port           = 1194
#   protocol          = "tcp"
#   cidr_blocks = ["0.0.0.0/0"]
#   security_group_id = module.vpn.sg_id
# }

# resource "aws_security_group_rule" "vpn_943" {
#   type              = "ingress"
#   from_port         = 943
#   to_port           = 943
#   protocol          = "tcp"
#   cidr_blocks = ["0.0.0.0/0"]
#   security_group_id = module.vpn.sg_id
# }


resource "aws_security_group_rule" "vpn_ingress" {
  for_each = toset([for p in local.vpn_ports : tostring(p)])

  type              = "ingress"
  from_port         = tonumber(each.value)
  to_port           = tonumber(each.value)
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}
resource "aws_security_group_rule" "backend_alb_vpn" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.backend_alb.sg_id
}
