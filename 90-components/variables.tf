variable "project" {
  default = "Roboshop"
  type    = string
}

variable "environment" {
  default = "dev"
  type    = string
}

variable "zone_id" {
  default = "Z08007301TGLKBZ7OY820"
  type    = string
}

variable "zone_name" {
  default = "gurulabs.xyz"
  type    = string
}

variable "components" {
  description = "Backend components configuration"
  type = map(object({
    rule_priority = number
  }))
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
  }
}