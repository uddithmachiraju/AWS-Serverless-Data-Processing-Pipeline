# Create a lambda function
resource "aws_lambda_function" "lambda_func" {
  function_name = "data-processing-pipeline"
  description   = "Used in the backend process for serverless data processing Pipeline"

  filename  = "/home/uddithmachiraju/Personal/AWS-Serverless-Data-Processing-Pipeline/src/modules/lambda/lambda_payload.zip" 
  handler   = "main.handler" 
  runtime   = "python3.10" 
  role      = var.role_arn 

  source_code_hash = filebase64sha256("/home/uddithmachiraju/Personal/AWS-Serverless-Data-Processing-Pipeline/src/modules/lambda/lambda_payload.zip")
}
