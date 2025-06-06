variable "aws_region" {
	description = "AWS region we need our resources to be deployed in"
	type = string 
	default = "us-east-1"
}

variable "stage" {
	description = "stage at where the deployment happens"
	type = string
	default = "dev"
}

