variable "project" {
    default = "Roboshop"  # Capital R - matches your SSM parameters
}

variable "environment" {
    default = "dev"
}

variable "zone_id" {
    default = "Z08007301TGLKBZ7OY820"
}

variable "zone_name" {
    default = "gurulabs.xyz"
}

variable "components" {
    default = {
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
        frontend = {
            rule_priority = 10
        }
    }
}