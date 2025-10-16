# module "frontend" {
#   source = "git::https://github.com/gurunani/terraform-aws-securitygroup.git?ref=main"
#   project = var.project
#   environment = var.environment
#   sg_name = var.frontend_sg_name
#   sg_description = var.frontend_sg_description
#   vpc_id = local.vpc_id
# }

# module "bastion" {
#   source = "git::https://github.com/gurunani/terraform-aws-securitygroup.git?ref=main"
#   project = var.project
#   environment = var.environment
#   sg_name = var.bastion_sg_name
#   sg_description = var.bastion_sg_description
#   vpc_id = local.vpc_id
# }
# module "backend_alb" {
#   source = "git::https://github.com/gurunani/terraform-aws-securitygroup.git?ref=main"
#   project = var.project
#   environment = var.environment
#   sg_name = var.backend_alb_sg_name
#   sg_description = var.backend_alb_sg_description
#   vpc_id = local.vpc_id
# }

# module "vpn" {
#   source = "git::https://github.com/gurunani/terraform-aws-securitygroup.git?ref=main"
#   project = var.project
#   environment = var.environment
#   sg_name = var.vpn_name
#   sg_description = var.vpn_description
#   vpc_id = local.vpc_id
# }
# module "mongodb" {
#   source = "git::https://github.com/gurunani/terraform-aws-securitygroup.git?ref=main"
#   project = var.project
#   environment = var.environment
#   sg_name = var.mongodb_name
#   sg_description = var.mongodb_description
#   vpc_id = local.vpc_id
# }

# # #bastion accpting connections from my laptop
# # resource "aws_security_group_rule" "mongodb_vpn_ssh" {
# #   count = length(var.mongodb_port_vpn)
# #   type              = "ingress"
# #   from_port         = var.mongodb_port_vpn[count.index]
# #   to_port           = var.mongodb_port_vpn[count.index]
# #   protocol          = "tcp"
# #   source_security_group_id = module.bastion.sg_id
# #   security_group_id = module.mongodb.sg_id
# # }
# resource "aws_security_group_rule" "mongodb_vpn_ssh" {
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   source_security_group_id = module.vpn.sg_id
#   security_group_id = module.mongodb.sg_id
# }

# resource "aws_security_group_rule" "mongodb_vpn_27017" {
#   type              = "ingress"
#   from_port         = 27017
#   to_port           = 27017
#   protocol          = "tcp"
#   source_security_group_id = module.vpn.sg_id
#   security_group_id = module.mongodb.sg_id
# }
# #bastion accpting connections from my laptop
# resource "aws_security_group_rule" "backend_alb_bastion" {
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   source_security_group_id = module.bastion.sg_id
#   security_group_id = module.backend_alb.sg_id
# }

# #VPN ports 22, 443, 1194, 943
# # resource "aws_security_group_rule" "vpn_ssh" {
# #   type              = "ingress"
# #   from_port         = 22
# #   to_port           = 22
# #   protocol          = "tcp"
# #   cidr_blocks = ["0.0.0.0/0"]
# #   security_group_id = module.vpn.sg_id
# # }

# # resource "aws_security_group_rule" "vpn_https" {
# #   type              = "ingress"
# #   from_port         = 443
# #   to_port           = 443
# #   protocol          = "tcp"
# #   cidr_blocks = ["0.0.0.0/0"]
# #   security_group_id = module.vpn.sg_id
# # }

# # resource "aws_security_group_rule" "vpn_1194" {
# #   type              = "ingress"
# #   from_port         = 1194
# #   to_port           = 1194
# #   protocol          = "tcp"
# #   cidr_blocks = ["0.0.0.0/0"]
# #   security_group_id = module.vpn.sg_id
# # }

# # resource "aws_security_group_rule" "vpn_943" {
# #   type              = "ingress"
# #   from_port         = 943
# #   to_port           = 943
# #   protocol          = "tcp"
# #   cidr_blocks = ["0.0.0.0/0"]
# #   security_group_id = module.vpn.sg_id
# # }


# resource "aws_security_group_rule" "vpn_ingress" {
#   for_each = toset([for p in local.vpn_ports : tostring(p)])

#   type              = "ingress"
#   from_port         = tonumber(each.value)
#   to_port           = tonumber(each.value)
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = module.vpn.sg_id
# }
# resource "aws_security_group_rule" "backend_alb_vpn" {
#   type              = "ingress"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
#   source_security_group_id = module.vpn.sg_id
#   security_group_id = module.backend_alb.sg_id
# }





# module "redis" {
#     #source = "../../terraform-aws-securitygroup"
#     source = "git::https://github.com/gurunani/terraform-aws-securitygroup.git?ref=main"
#     project = var.project
#     environment = var.environment

#     sg_name = "redis"
#     sg_description = "for redis"
#     vpc_id = local.vpc_id
# }

# module "mysql" {
#     #source = "../../terraform-aws-securitygroup"
#     source = "git::https://github.com/gurunani/terraform-aws-securitygroup.git?ref=main"
#     project = var.project
#     environment = var.environment

#     sg_name = "mysql"
#     sg_description = "for mysql"
#     vpc_id = local.vpc_id
# }

# module "rabbitmq" {
#     #source = "../../terraform-aws-securitygroup"
#     source = "git::https://github.com/gurunani/terraform-aws-securitygroup.git?ref=main"
#     project = var.project
#     environment = var.environment

#     sg_name = "rabbitmq"
#     sg_description = "for rabbitmq"
#     vpc_id = local.vpc_id
# }

# # Redis
# resource "aws_security_group_rule" "redis_vpn" {
#   count = length(var.redis_ports_vpn)
#   type              = "ingress"
#   from_port         = var.redis_ports_vpn[count.index]
#   to_port           = var.redis_ports_vpn[count.index]
#   protocol          = "tcp"
#   source_security_group_id = module.vpn.sg_id
#   security_group_id = module.redis.sg_id
# }

# resource "aws_security_group_rule" "redis_bastion" {
#   count = length(var.redis_ports_vpn)
#   type              = "ingress"
#   from_port         = var.redis_ports_vpn[count.index]
#   to_port           = var.redis_ports_vpn[count.index]
#   protocol          = "tcp"
#   source_security_group_id = module.bastion.sg_id
#   security_group_id = module.redis.sg_id
# }

# resource "aws_security_group_rule" "redis_user" {
#   type              = "ingress"
#   from_port         = 6379
#   to_port           = 6379
#   protocol          = "tcp"
#   source_security_group_id = module.user.sg_id
#   security_group_id = module.redis.sg_id
# }

# resource "aws_security_group_rule" "redis_cart" {
#   type              = "ingress"
#   from_port         = 6379
#   to_port           = 6379
#   protocol          = "tcp"
#   source_security_group_id = module.cart.sg_id
#   security_group_id = module.redis.sg_id
# }

# # MYSQL
# resource "aws_security_group_rule" "mysql_vpn" {
#   count = length(var.mysql_ports_vpn)
#   type              = "ingress"
#   from_port         = var.mysql_ports_vpn[count.index]
#   to_port           = var.mysql_ports_vpn[count.index]
#   protocol          = "tcp"
#   source_security_group_id = module.vpn.sg_id
#   security_group_id = module.mysql.sg_id
# }

# resource "aws_security_group_rule" "mysql_bastion" {
#   count = length(var.mysql_ports_vpn)
#   type              = "ingress"
#   from_port         = var.mysql_ports_vpn[count.index]
#   to_port           = var.mysql_ports_vpn[count.index]
#   protocol          = "tcp"
#   source_security_group_id = module.bastion.sg_id
#   security_group_id = module.mysql.sg_id
# }

# resource "aws_security_group_rule" "mysql_shipping" {
#   type              = "ingress"
#   from_port         = 3306
#   to_port           = 3306
#   protocol          = "tcp"
#   source_security_group_id = module.shipping.sg_id
#   security_group_id = module.mysql.sg_id
# }


# # RabbitMQ
# resource "aws_security_group_rule" "rabbitmq_vpn" {
#   count = length(var.rabbitmq_ports_vpn)
#   type              = "ingress"
#   from_port         = var.rabbitmq_ports_vpn[count.index]
#   to_port           = var.rabbitmq_ports_vpn[count.index]
#   protocol          = "tcp"
#   source_security_group_id = module.vpn.sg_id
#   security_group_id = module.rabbitmq.sg_id
# }

# resource "aws_security_group_rule" "rabbitmq_bastion" {
#   count = length(var.rabbitmq_ports_vpn)
#   type              = "ingress"
#   from_port         = var.rabbitmq_ports_vpn[count.index]
#   to_port           = var.rabbitmq_ports_vpn[count.index]
#   protocol          = "tcp"
#   source_security_group_id = module.bastion.sg_id
#   security_group_id = module.rabbitmq.sg_id
# }

# resource "aws_security_group_rule" "rabbitmq_payment" {
#   type              = "ingress"
#   from_port         = 5672
#   to_port           = 5672
#   protocol          = "tcp"
#   source_security_group_id = module.payment.sg_id
#   security_group_id = module.rabbitmq.sg_id
# }


# 1. Security Group Modules

# Frontend Security Group
module "frontend" {
  source            = "git::https://github.com/gurunani/terraform-aws-securitygroup.git?ref=main"
  project           = var.project
  environment       = var.environment
  sg_name           = var.frontend_sg_name
  sg_description    = var.frontend_sg_description
  vpc_id            = local.vpc_id
}

# Bastion Security Group
module "bastion" {
  source            = "git::https://github.com/gurunani/terraform-aws-securitygroup.git?ref=main"
  project           = var.project
  environment       = var.environment
  sg_name           = var.bastion_sg_name
  sg_description    = var.bastion_sg_description
  vpc_id            = local.vpc_id
}

# Backend ALB Security Group
module "backend_alb" {
  source            = "git::https://github.com/gurunani/terraform-aws-securitygroup.git?ref=main"
  project           = var.project
  environment       = var.environment
  sg_name           = var.backend_alb_sg_name
  sg_description    = var.backend_alb_sg_description
  vpc_id            = local.vpc_id
}

# VPN Security Group
module "vpn" {
  source            = "git::https://github.com/gurunani/terraform-aws-securitygroup.git?ref=main"
  project           = var.project
  environment       = var.environment
  sg_name           = var.vpn_name
  sg_description    = var.vpn_description
  vpc_id            = local.vpc_id
}

# MongoDB Security Group
module "mongodb" {
  source            = "git::https://github.com/gurunani/terraform-aws-securitygroup.git?ref=main"
  project           = var.project
  environment       = var.environment
  sg_name           = var.mongodb_name
  sg_description    = var.mongodb_description
  vpc_id            = local.vpc_id
}

# Redis Security Group
module "redis" {
  source            = "git::https://github.com/gurunani/terraform-aws-securitygroup.git?ref=main"
  project           = var.project
  environment       = var.environment
  sg_name           = "redis"
  sg_description    = "for redis"
  vpc_id            = local.vpc_id
}

# MySQL Security Group
module "mysql" {
  source            = "git::https://github.com/gurunani/terraform-aws-securitygroup.git?ref=main"
  project           = var.project
  environment       = var.environment
  sg_name           = "mysql"
  sg_description    = "for mysql"
  vpc_id            = local.vpc_id
}

# RabbitMQ Security Group
module "rabbitmq" {
  source            = "git::https://github.com/gurunani/terraform-aws-securitygroup.git?ref=main"
  project           = var.project
  environment       = var.environment
  sg_name           = "rabbitmq"
  sg_description    = "for rabbitmq"
  vpc_id            = local.vpc_id
}

# 2. Security Group Rules

# MongoDB Security Group Rules

# VPN SSH Rule (Allow VPN to access MongoDB on port 22)
resource "aws_security_group_rule" "mongodb_vpn_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.mongodb.sg_id
}

# VPN MongoDB Rule (Allow VPN to access MongoDB on port 27017)
resource "aws_security_group_rule" "mongodb_vpn_27017" {
  type                     = "ingress"
  from_port                = 27017
  to_port                  = 27017
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.mongodb.sg_id
}

# Backend ALB Security Group Rules

# Bastion SSH Rule (Allow Bastion to access Backend ALB on port 22)
resource "aws_security_group_rule" "backend_alb_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.backend_alb.sg_id
}

# VPN HTTP Rule (Allow VPN to access Backend ALB on port 80)
resource "aws_security_group_rule" "backend_alb_vpn" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.backend_alb.sg_id
}

# VPN Security Group Rules

# VPN Ingress Rules (Allow multiple ports for VPN)
resource "aws_security_group_rule" "vpn_ingress" {
  for_each = toset([for p in local.vpn_ports : tostring(p)])

  type                     = "ingress"
  from_port                = tonumber(each.value)
  to_port                  = tonumber(each.value)
  protocol                 = "tcp"
  cidr_blocks             = ["0.0.0.0/0"]
  security_group_id        = module.vpn.sg_id
}

# Redis Security Group Rules

# VPN Access to Redis Rule
resource "aws_security_group_rule" "redis_vpn" {
  count                    = length(var.redis_ports_vpn)
  type                     = "ingress"
  from_port                = var.redis_ports_vpn[count.index]
  to_port                  = var.redis_ports_vpn[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.redis.sg_id
}

# Bastion Access to Redis Rule
resource "aws_security_group_rule" "redis_bastion" {
  count                    = length(var.redis_ports_vpn)
  type                     = "ingress"
  from_port                = var.redis_ports_vpn[count.index]
  to_port                  = var.redis_ports_vpn[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.redis.sg_id
}

# User Access to Redis Rule
resource "aws_security_group_rule" "redis_user" {
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = module.user.sg_id
  security_group_id        = module.redis.sg_id
}

# Cart Service Access to Redis Rule
resource "aws_security_group_rule" "redis_cart" {
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = module.cart.sg_id
  security_group_id        = module.redis.sg_id
}

# MySQL Security Group Rules

# VPN Access to MySQL Rule
resource "aws_security_group_rule" "mysql_vpn" {
  count                    = length(var.mysql_ports_vpn)
  type                     = "ingress"
  from_port                = var.mysql_ports_vpn[count.index]
  to_port                  = var.mysql_ports_vpn[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.mysql.sg_id
}

# Bastion Access to MySQL Rule
resource "aws_security_group_rule" "mysql_bastion" {
  count                    = length(var.mysql_ports_vpn)
  type                     = "ingress"
  from_port                = var.mysql_ports_vpn[count.index]
  to_port                  = var.mysql_ports_vpn[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.mysql.sg_id
}

# Shipping Service Access to MySQL Rule
resource "aws_security_group_rule" "mysql_shipping" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.shipping.sg_id
  security_group_id        = module.mysql.sg_id
}

# RabbitMQ Security Group Rules

# VPN Access to RabbitMQ Rule
resource "aws_security_group_rule" "rabbitmq_vpn" {
  count                    = length(var.rabbitmq_ports_vpn)
  type                     = "ingress"
  from_port                = var.rabbitmq_ports_vpn[count.index]
  to_port                  = var.rabbitmq_ports_vpn[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id        = module.rabbitmq.sg_id
}

# Bastion Access to RabbitMQ Rule
resource "aws_security_group_rule" "rabbitmq_bastion" {
  count                    = length(var.rabbitmq_ports_vpn)
  type                     = "ingress"
  from_port                = var.rabbitmq_ports_vpn[count.index]
  to_port                  = var.rabbitmq_ports_vpn[count.index]
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module
}