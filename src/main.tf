provider "aws" {
  region = var.aws_region
}

module "api_gateway" {
  source      = "./modules/api_gateway"
  aws_region  = var.aws_region
}