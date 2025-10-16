locals {
    vpc_id = data.aws_ssm_parameter.vpc_id.value
}

locals {
  vpn_ports = [22, 443, 1194, 943]
}
