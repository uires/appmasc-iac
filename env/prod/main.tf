module "aws-prod" {
  source                     = "../../infra"
  instance                   = "t2.micro"
  region_aws                 = "us-west-1"
  key                        = "default-key-prod"
  env-alias                  = "prod"
  security_group             = "prod"
  autoscaling_group_max_size = 10
  autoscaling_group_min_size = 1
  autoscaling_group_name     = "production"
  production                 = true
}
