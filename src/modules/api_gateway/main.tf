# In this module we are going to create a API Gateway for '/submit' endpoint

# Create a REST API
resource "aws_api_gateway_rest_api" "serverless-D2P" {
  name        = "Serverless Data Processing Pipeline"
  description = "Creating a serverless data processing pipeline that triggers lambda function when new data arrives and stores the data in DynamoDB after preprocessing it."
}

# Create the resource needed ('/submit') 
resource "aws_api_gateway_resource" "submit_route" {
  rest_api_id   = aws_api_gateway_rest_api.serverless-D2P.id 
  parent_id     = aws_api_gateway_rest_api.serverless-D2P.root_resource_id
  path_part     = "submit" 
}

# Create a method for the resource we created (POST) 
resource "aws_api_gateway_method" "post_submit" {
  rest_api_id   = aws_api_gateway_rest_api.serverless-D2P.id 
  resource_id   = aws_api_gateway_resource.submit_route.id 
  authorization = "NONE" 
  http_method   = "POST"
}

# Integrate it with AWS Lambda (if we use lambda we need to add permisions to API Gateway to invoke the lambda) 
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.serverless-D2P.id 
  resource_id = aws_api_gateway_resource.submit_route.id 
  http_method = aws_api_gateway_method.post_submit.http_method 
  integration_http_method = "POST" 
  type        = "AWS_PROXY"
  uri         = var.invoke_arn

}

# Lambda permission to API Gateway 
resource "aws_lambda_permission" "permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_func
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.serverless-D2P.execution_arn}/*/*"
}

# These guys only require when using MOCK

# # Add a method response for the method (POST) we created
# resource "aws_api_gateway_method_response" "post_submit_response" {
#   rest_api_id = aws_api_gateway_rest_api.serverless-D2P.id 
#   resource_id = aws_api_gateway_resource.submit_route.id
#   http_method = aws_api_gateway_method.post_submit.http_method 
#   status_code = "200" 

#   response_models = {
#     "application/json" = "Empty"
#   }
# }

# # We need to add a integration response (to MOCK)
# resource "aws_api_gateway_integration_response" "post_submit_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.serverless-D2P.id 
#   resource_id = aws_api_gateway_resource.submit_route.id 
#   http_method = aws_api_gateway_method.post_submit.http_method 
#   status_code = aws_api_gateway_method_response.post_submit_response.status_code

#   response_templates = {
#     "application/json" = <<EOF
#     {
#       "message": "It is a post method in /submit URL"
#     }
#     EOF
#   }
# }

# Deploy out API 
resource "aws_api_gateway_deployment" "mock_deployment" {
  depends_on  = [aws_api_gateway_integration.lambda_integration] 
  rest_api_id = aws_api_gateway_rest_api.serverless-D2P.id 
  stage_name  = "dev" 
}