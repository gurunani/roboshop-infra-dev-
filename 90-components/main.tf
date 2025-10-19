# Backend Components (catalogue, user, cart, shipping, payment)
module "backend_components" {
  for_each = {
    catalogue = {
      rule_priority = 10
    }
    user = {
      rule_priority = 20
    }
    cart = {
      rule_priority = 30
    }
    shipping = {
      rule_priority = 40
    }
    payment = {
      rule_priority = 50
    }
  }
  
  source = "git::https://github.com/daws-84s/terraform-aws-roboshop.git?ref=main"
  component = each.key
  rule_priority = each.value.rule_priority
  project = var.project
  environment = var.environment
  zone_name = var.zone_name
  zone_id = var.zone_id
}

# Frontend Component (separate handling)
module "frontend" {
  source = "git::https://github.com/gurunani/terraform-aws-roboshop.git?ref=main"
  component = "frontend"
  rule_priority = 10
  project = var.project
  environment = var.environment
  zone_name = var.zone_name
  zone_id = var.zone_id
}