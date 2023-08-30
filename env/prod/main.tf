module "aws-prod" {
  source     = "../../infra"
  instance   = "t2.micro"
  region_aws = "us-west-1"
  key        = "default-key-prod"
  env-alias  = "prod"
}

output "public_ip_prod" {
  value = module.aws-prod.public_ip
}
