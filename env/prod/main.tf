module "aws_prod" {
  source     = "../../infra"
  instance   = "t2.micro"
  region_aws = "us-west-1"
  key        = "default-key-prod"
}

