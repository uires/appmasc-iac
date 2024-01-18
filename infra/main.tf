terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.region_aws
}

resource "aws_launch_template" "machine" {
  image_id             = "ami-0f8e81a3da6e2510a"
  instance_type        = var.instance
  key_name             = var.key
  security_group_names = [var.security_group]
  tags = {
    Name = "AppMasc_v0_1-${var.env-alias}"
  }
  user_data = filebase64("ansible.sh")
}

resource "aws_key_pair" "sshKey" {
  key_name   = var.key
  public_key = file("${var.key}.pub")
}

resource "aws_autoscaling_group" "autoscaling_group" {
  availability_zones = ["${var.region_aws}b", "${var.region_aws}c"]
  name               = var.autoscaling_group_name
  max_size           = var.autoscaling_group_max_size
  min_size           = var.autoscaling_group_min_size
  target_group_arns  = [aws_lb_target_group.target_load_balancer.arn]
  launch_template {
    id      = aws_launch_template.machine.id
    version = "$Latest"
  }
}

resource "aws_default_subnet" "subnet_1" {
  availability_zone = "${var.region_aws}b"
}

resource "aws_default_subnet" "subnet_2" {
  availability_zone = "${var.region_aws}c"
}

resource "aws_lb" "load_balancer" {
  internal        = false
  subnets         = [aws_default_subnet.subnet_1.id, aws_default_subnet.subnet_2.id]
  security_groups = [aws_security_group.general-access.id]
}

resource "aws_lb_target_group" "target_load_balancer" {
  name     = "target"
  port     = "8000"
  protocol = "HTTP"
  vpc_id   = aws_default_vpc.default.id
}

resource "aws_default_vpc" "default" {}

resource "aws_lb_listener" "load_balancer_entry_point" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "8000"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_load_balancer.arn
  }
}

resource "aws_autoscaling_policy" "autoscaling_policy" {
  name = "default_scaling"
  autoscaling_group_name = var.autoscaling_group_name
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}