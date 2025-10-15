#  output "azs_info" {
#     value = module.vpc.azs_info
# } 
# output "public_subnet_ids" {
#   value = aws_subnet.public_ip[*].id
# }
output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}