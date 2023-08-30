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

resource "aws_instance" "app_server" {
  ami             = "ami-0f8e81a3da6e2510a"
  instance_type   = var.instance
  security_groups = ["general-access"]
  key_name        = var.key
  tags = {
    Name = "AppMasc_v0_1"
  }
}

resource "aws_key_pair" "sshKey" {
  key_name   = var.key
  public_key = file("${var.key}.pub")
}

output "public_ip" {
  value = aws_instance.app_server.public_ip
}
