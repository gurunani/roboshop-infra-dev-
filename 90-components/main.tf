module "component" {
    for_each = var.components
    source = "git::https://github.com/gurunani/terraform-aws-roboshop.git?ref=main"
    
    project       = var.project
    environment   = var.environment
    zone_name     = var.zone_name
    zone_id       = var.zone_id
    component     = each.key
    rule_priority = each.value.rule_priority
}