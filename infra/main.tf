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
  availability_zones = ["${var.region_aws}b"]
  name               = var.autoscaling_group_name
  max_size           = var.autoscaling_group_max_size
  min_size           = var.autoscaling_group_min_size
  launch_template {
    id      = aws_launch_template.machine.id
    version = "$Latest"
  }

}
