variable "region_aws" {
  type = string
}

variable "key" {
  type = string
}

variable "instance" {
  type = string
}

variable "env-alias" {
  type = string
}

variable "security_group" {
  type = string
}

variable "autoscaling_group_name" {
  type = string
}

variable "autoscaling_group_max_size" {
  type = number
}

variable "autoscaling_group_min_size" {
  type = number
}