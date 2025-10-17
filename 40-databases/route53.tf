# # Get the private hosted zone
# data "aws_route53_zone" "roboshop" {
#   name         = var.zone_name
#   private_zone = true
# }

# # MongoDB Route53 Record
# resource "aws_route53_record" "mongodb" {
#   zone_id = data.aws_route53_zone.roboshop.zone_id
#   name    = "mongodb.${var.zone_name}"
#   type    = "A"
#   ttl     = 1
#   records = [aws_instance.mongodb.private_ip]
# }

# # Redis Route53 Record
# resource "aws_route53_record" "redis" {
#   zone_id = data.aws_route53_zone.roboshop.zone_id
#   name    = "redis.${var.zone_name}"
#   type    = "A"
#   ttl     = 1
#   records = [aws_instance.redis.private_ip]
# }

# # MySQL Route53 Record
# resource "aws_route53_record" "mysql" {
#   zone_id = data.aws_route53_zone.roboshop.zone_id
#   name    = "mysql.${var.zone_name}"
#   type    = "A"
#   ttl     = 1
#   records = [aws_instance.mysql.private_ip]
# }

# # RabbitMQ Route53 Record
# resource "aws_route53_record" "rabbitmq" {
#   zone_id = data.aws_route53_zone.roboshop.zone_id
#   name    = "rabbitmq.${var.zone_name}"
#   type    = "A"
#   ttl     = 1
#   records = [aws_instance.rabbitmq.private_ip]
# }