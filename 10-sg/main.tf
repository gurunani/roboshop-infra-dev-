# 1. Security Group Modules - Infrastructure Components

# Frontend Security Group
module "frontend" {
  source         = "git::https://github.com/gurunani/terraform-aws-securitygroup.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = var.frontend_sg_name
  sg_description = var.frontend_sg_description
  vpc_id         = local.vpc_id
}

# Bastion Security Group
module "bastion" {
  source         = "git::https://github.com/gurunani/terraform-aws-securitygroup.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = var.bastion_sg_name
  sg_description = var.bastion_sg_description
  vpc_id         = local.vpc_id
}

# Backend ALB Security Group
module "backend_alb" {
  source         = "git::https://github.com/gurunani/terraform-aws-securitygroup.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = var.backend_alb_sg_name
  sg_description = var.backend_alb_sg_description
  vpc_id         = local.vpc_id
}

# VPN Security Group
module "vpn" {
  source         = "git::https://github.com/gurunani/terraform-aws-securitygroup.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = var.vpn_name
  sg_description = var.vpn_description
  vpc_id         = local.vpc_id
}

# 2. Security Group Modules - Database Components

# MongoDB Security Group
module "mongodb" {
  source         = "git::https://github.com/gurunani/terraform-aws-securitygroup.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = var.mongodb_name
  sg_description = var.mongodb_description
  vpc_id         = local.vpc_id
}

# Redis Security Group
module "redis" {
  source         = "git::https://github.com/gurunani/terraform-aws-securitygroup.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = "redis"
  sg_description = "for redis"
  vpc_id         = local.vpc_id
}

# MySQL Security Group
module "mysql" {
  source         = "git::https://github.com/gurunani/terraform-aws-securitygroup.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = "mysql"
  sg_description = "for mysql"
  vpc_id         = local.vpc_id
}

# RabbitMQ Security Group
module "rabbitmq" {
  source         = "git::https://github.com/gurunani/terraform-aws-securitygroup.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = "rabbitmq"
  sg_description = "for rabbitmq"
  vpc_id         = local.vpc_id
}

# 3. Security Group Modules - Application Services

# User Service Security Group
module "user" {
  source         = "git::https://github.com/gurunani/terraform-aws-securitygroup.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = "user"
  sg_description = "for user service"
  vpc_id         = local.vpc_id
}

# Cart Service Security Group
module "cart" {
  source         = "git::https://github.com/gurunani/terraform-aws-securitygroup.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = "cart"
  sg_description = "for cart service"
  vpc_id         = local.vpc_id
}

# Shipping Service Security Group
module "shipping" {
  source         = "git::https://github.com/gurunani/terraform-aws-securitygroup.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = "shipping"
  sg_description = "for shipping service"
  vpc_id         = local.vpc_id
}

# Payment Service Security Group
module "payment" {
  source         = "git::https://github.com/gurunani/terraform-aws-securitygroup.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = "payment"
  sg_description = "for payment service"
  vpc_id         = local.vpc_id
}

# Catalogue Service Security Group
module "catalogue" {
  source         = "git::https://github.com/gurunani/terraform-aws-securitygroup.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = "catalogue"
  sg_description = "for catalogue service"
  vpc_id         = local.vpc_id
}

# 4. Security Group Rules - VPN Access

# VPN Ingress Rules (Allow multiple ports: 22, 443, 1194, 943)
resource "aws_security_group_rule" "vpn_ingress" {
  for_each = toset([for p in local.vpn_ports : tostring(p)])

  type              = "ingress"
  from_port         = tonumber(each.value)
  to_port           = tonumber(each.value)
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

# 5. Security Group Rules - MongoDB Access

# VPN SSH Access to MongoDB
resource "aws_security_group_rule" "mongodb_vpn_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.mongodb.sg_id
}

# VPN MongoDB Port Access
resource "aws_security_group_rule" "mongodb_vpn_27017" {
  type                     = "ingress"
  from_port                = 27017
  to_port                  = 27017
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.mongodb.sg_id
}

# Catalogue Service Access to MongoDB
resource "aws_security_group_rule" "mongodb_catalogue" {
  type                     = "ingress"
  from_port                = 27017
  to_port                  = 27017
  protocol                 = "tcp"
  source_security_group_id = module.catalogue.sg_id
  security_group_id        = module.mongodb.sg_id
}

# User Service Access to MongoDB
resource "aws_security_group_rule" "mongodb_user" {
  type                     = "ingress"
  from_port                = 27017
  to_port                  = 27017
  protocol                 = "tcp"
  source_security_group_id = module.user.sg_id
  security_group_id        = module.mongodb.sg_id
}

# 6. Security Group Rules - Backend ALB Access

# Bastion SSH Access to Backend ALB
resource "aws_security_group_rule" "backend_alb_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.backend_alb.sg_id
}

# VPN HTTP Access to Backend ALB
resource "aws_security_group_rule" "backend_alb_vpn" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.backend_alb.sg_id
}

# Frontend Access to Backend ALB
resource "aws_security_group_rule" "backend_alb_frontend" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.frontend.sg_id
  security_group_id        = module.backend_alb.sg_id
}

# 7. Security Group Rules - Redis Access

# VPN Access to Redis (multiple ports)
resource "aws_security_group_rule" "redis_vpn" {
  count                    = length(var.redis_ports_vpn)
  type                     = "ingress"
  from_port                = var.redis_ports_vpn[count.index]
  to_port                  = var.redis_ports_vpn[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.redis.sg_id
}

# Bastion Access to Redis
resource "aws_security_group_rule" "redis_bastion" {
  count                    = length(var.redis_ports_vpn)
  type                     = "ingress"
  from_port                = var.redis_ports_vpn[count.index]
  to_port                  = var.redis_ports_vpn[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.redis.sg_id
}

# User Service Access to Redis
resource "aws_security_group_rule" "redis_user" {
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = module.user.sg_id
  security_group_id        = module.redis.sg_id
}

# Cart Service Access to Redis
resource "aws_security_group_rule" "redis_cart" {
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = module.cart.sg_id
  security_group_id        = module.redis.sg_id
}

# 8. Security Group Rules - MySQL Access

# VPN Access to MySQL (multiple ports)
resource "aws_security_group_rule" "mysql_vpn" {
  count                    = length(var.mysql_ports_vpn)
  type                     = "ingress"
  from_port                = var.mysql_ports_vpn[count.index]
  to_port                  = var.mysql_ports_vpn[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.mysql.sg_id
}

# Bastion Access to MySQL
resource "aws_security_group_rule" "mysql_bastion" {
  count                    = length(var.mysql_ports_vpn)
  type                     = "ingress"
  from_port                = var.mysql_ports_vpn[count.index]
  to_port                  = var.mysql_ports_vpn[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.mysql.sg_id
}

# Shipping Service Access to MySQL
resource "aws_security_group_rule" "mysql_shipping" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.shipping.sg_id
  security_group_id        = module.mysql.sg_id
}

# 9. Security Group Rules - RabbitMQ Access

# VPN Access to RabbitMQ (multiple ports)
resource "aws_security_group_rule" "rabbitmq_vpn" {
  count                    = length(var.rabbitmq_ports_vpn)
  type                     = "ingress"
  from_port                = var.rabbitmq_ports_vpn[count.index]
  to_port                  = var.rabbitmq_ports_vpn[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.rabbitmq.sg_id
}

# Bastion Access to RabbitMQ
resource "aws_security_group_rule" "rabbitmq_bastion" {
  count                    = length(var.rabbitmq_ports_vpn)
  type                     = "ingress"
  from_port                = var.rabbitmq_ports_vpn[count.index]
  to_port                  = var.rabbitmq_ports_vpn[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.rabbitmq.sg_id
}

# Payment Service Access to RabbitMQ
resource "aws_security_group_rule" "rabbitmq_payment" {
  type                     = "ingress"
  from_port                = 5672
  to_port                  = 5672
  protocol                 = "tcp"
  source_security_group_id = module.payment.sg_id
  security_group_id        = module.rabbitmq.sg_id
}

# 10. Security Group Rules - Application Services Access to Backend ALB

# User Service Access from Backend ALB
resource "aws_security_group_rule" "user_backend_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.backend_alb.sg_id
  security_group_id        = module.user.sg_id
}

# Cart Service Access from Backend ALB
resource "aws_security_group_rule" "cart_backend_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.backend_alb.sg_id
  security_group_id        = module.cart.sg_id
}

# Shipping Service Access from Backend ALB
resource "aws_security_group_rule" "shipping_backend_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.backend_alb.sg_id
  security_group_id        = module.shipping.sg_id
}

# Payment Service Access from Backend ALB
resource "aws_security_group_rule" "payment_backend_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.backend_alb.sg_id
  security_group_id        = module.payment.sg_id
}

# Catalogue Service Access from Backend ALB
resource "aws_security_group_rule" "catalogue_backend_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.backend_alb.sg_id
  security_group_id        = module.catalogue.sg_id
}

# 11. Security Group Rules - VPN SSH Access to Application Services

# VPN SSH Access to User Service
resource "aws_security_group_rule" "user_vpn_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.user.sg_id
}

# VPN SSH Access to Cart Service
resource "aws_security_group_rule" "cart_vpn_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.cart.sg_id
}

# VPN SSH Access to Shipping Service
resource "aws_security_group_rule" "shipping_vpn_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.shipping.sg_id
}

# VPN SSH Access to Payment Service
resource "aws_security_group_rule" "payment_vpn_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.payment.sg_id
}

# VPN SSH Access to Catalogue Service
resource "aws_security_group_rule" "catalogue_vpn_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.catalogue.sg_id
}

module "frontend_alb" {
    #source = "../../terraform-aws-securitygroup"
    source = "git::https://github.com/daws-84s/terraform-aws-securitygroup.git?ref=main"  #notgurunani git
    project = var.project
    environment = var.environment

    sg_name = "frontend-alb"
    sg_description = "for frontend alb"
    vpc_id = local.vpc_id
}

resource "aws_security_group_rule" "frontend_alb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.frontend_alb.sg_id
}

resource "aws_security_group_rule" "frontend_alb_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.backend_alb.sg_id
}
