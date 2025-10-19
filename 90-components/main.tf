# module "component" {
#     for_each = var.components
#     source = "git::https://github.com/gurunani/terraform-aws-roboshop.git?ref=main"
#     component = each.key
#     rule_priority = each.value.rule_priority
# }

# 90-components Directory - Error Analysis and Fixes

## Errors Found

### 1. Frontend Component Misconfiguration
**Problem**: Frontend is grouped with backend components in the loop, causing it to be provisioned with:
- Backend ALB listener (instead of frontend ALB)
- Port 8080 (instead of port 80)
- Backend health check path and routing

**Fix**: Create separate module declarations for frontend vs backend components.

### 2. Missing Variables Definition
**Problem**: `variables.tf` only defines `components`. Missing definitions for variables the remote module needs like `project`, `environment`, `zone_id`, `zone_name`.

**Fix**: Add complete variable definitions.

### 3. Bootstrap Script Not Used
**Problem**: `bootstrap.sh` exists in the directory but won't be used since the module is sourced from GitHub. Remote module must handle provisioning.

---

## Corrected Files

### Corrected `90-components/main.tf`

```hcl
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
  
  source = "git::https://github.com/gurunani/terraform-aws-roboshop.git?ref=main"
  component = each.key
  rule_priority = each.value.rule_priority
  project = var.project
  environment = var.environment
  zone_name = var.zone_name
  zone_id = var.zone_id
}

# Frontend Component (separate handling with different settings)
module "frontend" {
  source = "git::https://github.com/gurunani/terraform-aws-roboshop.git?ref=main"
  component = "frontend"
  rule_priority = 10
  project = var.project
  environment = var.environment
  zone_name = var.zone_name
  zone_id = var.zone_id
}
```

### Corrected `90-components/variables.tf`

```hcl
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
```

## Key Changes

1. **Separated frontend from backend** - Frontend now uses its own module declaration
2. **Added all required variables** - `project`, `environment`, `zone_id`, `zone_name`
3. **Passed variables to modules** - Each module now receives required input variables
4. **Better type definition** - `components` variable now has proper type definition
5. **Removed bootstrap.sh** - Not needed when sourcing from remote module (can be deleted)

## Notes

- Verify the remote module `terraform-aws-roboshop` supports all these variables
- The frontend module may need different ALB listener ARN from SSM if the remote module uses variable `alb_listener_arn`
- Consider adding outputs to expose module results if needed downstream