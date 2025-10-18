resource "aws_lb_target_group" "catalogue" {
  name     = "${var.project}-${var.environment}-catalogue"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  deregistration_delay = 60
  
  health_check {
    healthy_threshold   = 2
    interval            = 15
    matcher             = "200-299"
    path                = "/health"
    port                = 8080
    timeout             = 5
    unhealthy_threshold = 3
  }
}

# Listener Rule to route traffic to catalogue
resource "aws_lb_listener_rule" "catalogue" {
  listener_arn = local.backend_alb_listener_arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.catalogue.arn
  }

  condition {
    host_header {
      values = ["catalogue.backend-dev.${var.zone_name}"]
    }
  }
}

resource "aws_instance" "catalogue" {
  ami                    = local.ami_id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [local.catalogue_sg_id]
  subnet_id              = local.private_subnet_id
  
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-catalogue"
    }
  )
}

# Provision catalogue instance
resource "terraform_data" "catalogue" {
  triggers_replace = [
    aws_instance.catalogue.id
  ]
  
  provisioner "file" {
    source      = "catalogue.sh"
    destination = "/tmp/catalogue.sh"
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.catalogue.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/catalogue.sh",
      "sudo sh /tmp/catalogue.sh catalogue ${var.environment}"
    ]
  }
}

# Stop instance to create AMI
resource "aws_ec2_instance_state" "catalogue" {
  instance_id = aws_instance.catalogue.id
  state       = "stopped"
  depends_on  = [terraform_data.catalogue]
}

# Create AMI from the configured instance
resource "aws_ami_from_instance" "catalogue" {
  name               = "${var.project}-${var.environment}-catalogue-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
  source_instance_id = aws_instance.catalogue.id
  depends_on         = [aws_ec2_instance_state.catalogue]
  
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-catalogue"
    }
  )
}

# Terminate the instance after AMI creation
resource "terraform_data" "catalogue_delete" {
  triggers_replace = [
    aws_ami_from_instance.catalogue.id
  ]
  
  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.catalogue.id}"
  }

  depends_on = [aws_ami_from_instance.catalogue]
}

# Launch Template for Auto Scaling
resource "aws_launch_template" "catalogue" {
  name_prefix = "${var.project}-${var.environment}-catalogue"

  image_id                             = aws_ami_from_instance.catalogue.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "t3.micro"
  vpc_security_group_ids               = [local.catalogue_sg_id]
  update_default_version               = true

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      local.common_tags,
      {
        Name = "${var.project}-${var.environment}-catalogue"
      }
    )
  }
  
  depends_on = [terraform_data.catalogue_delete]
}

# Auto Scaling Group
resource "aws_autoscaling_group" "catalogue" {
  name_prefix         = "${var.project}-${var.environment}-catalogue"
  vpc_zone_identifier = local.private_subnet_ids
  desired_capacity    = 2
  max_size            = 4
  min_size            = 2
  health_check_type   = "ELB"
  health_check_grace_period = 120
  target_group_arns   = [aws_lb_target_group.catalogue.arn]

  launch_template {
    id      = aws_launch_template.catalogue.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project}-${var.environment}-catalogue"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = var.project
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }

  depends_on = [aws_launch_template.catalogue]
}

# Auto Scaling Policy - Scale Up
resource "aws_autoscaling_policy" "catalogue_scale_up" {
  name                   = "${var.project}-${var.environment}-catalogue-scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 120
  autoscaling_group_name = aws_autoscaling_group.catalogue.name
}

# Auto Scaling Policy - Scale Down
resource "aws_autoscaling_policy" "catalogue_scale_down" {
  name                   = "${var.project}-${var.environment}-catalogue-scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 120
  autoscaling_group_name = aws_autoscaling_group.catalogue.name
}

# CloudWatch Alarm - High CPU
resource "aws_cloudwatch_metric_alarm" "catalogue_cpu_high" {
  alarm_name          = "${var.project}-${var.environment}-catalogue-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 70

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.catalogue.name
  }

  alarm_actions = [aws_autoscaling_policy.catalogue_scale_up.arn]
}

# CloudWatch Alarm - Low CPU
resource "aws_cloudwatch_metric_alarm" "catalogue_cpu_low" {
  alarm_name          = "${var.project}-${var.environment}-catalogue-cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 30

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.catalogue.name
  }

  alarm_actions = [aws_autoscaling_policy.catalogue_scale_down.arn]
}