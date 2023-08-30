module "aws-dev" {
  source     = "../../infra"
  instance   = "t2.micro"
  region_aws = "us-west-1"
  key        = "default-key-dev"
}

output "public_ip_dev" {
  value = module.aws-dev.public_ip
}
