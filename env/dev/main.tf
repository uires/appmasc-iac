module "aws-dev" {
  source     = "../../infra"
  instance   = "t2.micro"
  region_aws = "us-west-1"
  key        = "default-key-dev"
  env-alias  = "dev"
  security_group = "dev"
  autoscaling_group_max_size = 1
  autoscaling_group_min_size = 0
  autoscaling_group_name = "development"
  production                 = false
}

