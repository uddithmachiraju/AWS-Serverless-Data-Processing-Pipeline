provider "aws" {
	region = var.aws_region
}

resource "aws_lambda_function" "test_lambda" {
	function_name = "my-personal-lambda-function"
	description	  = "Just playing with lambda function and testing things out of it."

	filename = "lambda_payload.zip"

	# Specify the function in our code
	handler = "main.handler"

	# Provide a runtime for the code
	runtime = "python3.10"

	# Lambda needs an IAM role to run 
	role = aws_iam_role.lambda_exec.arn
}

resource "aws_iam_role" "lambda_exec" {
	name = "lambda-exectution-role"

	assume_role_policy = jsonencode(
		{
			Version = "2012-10-17"
			Statement = [
				{
					Action = "sts:AssumeRole"
					Effect = "Allow"
					Principal = {
						Service = "lambda.amazonaws.com"
					}
				}
			]
		}
	)
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
	role = aws_iam_role.lambda_exec.name
	policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}