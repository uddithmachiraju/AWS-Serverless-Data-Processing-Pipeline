provider "aws" {
  region = var.aws_region
}

module "iam" {
  source = "./modules/iam" 
}

module "lambda" {
  source      = "./modules/lambda" 
  aws_region  = var.aws_region 
  role_arn    = module.iam.role_arn
}

module "api_gateway" {
  source      = "./modules/api_gateway"
  aws_region  = var.aws_region
  invoke_arn  = module.lambda.invoke_arn
  lambda_func = module.lambda.function_name
}