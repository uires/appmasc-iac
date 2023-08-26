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
  region = "us-west-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0f8e81a3da6e2510a"
  instance_type = "t2.micro"
  key_name      = "default-california"
  tags = {
    Name = "AppMasc_v0_1"
  }
}