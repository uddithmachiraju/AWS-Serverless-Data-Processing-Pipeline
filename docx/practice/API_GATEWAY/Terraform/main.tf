# AWS Provider
provider "aws" {
    region = "us-east-1" 
}

# Create a REST API 
resource "aws_api_gateway_rest_api" "my_rest_api" {
    name        = "my_example_rest_api"
    description = "This is the testing REST API I was trying to create to gain more understanding on API Gateways and more."
}

# Create a Resource(a route) as of now we do /hello
resource "aws_api_gateway_resource" "hello_route" {
    rest_api_id = aws_api_gateway_rest_api.my_rest_api.id 
    parent_id   = aws_api_gateway_rest_api.my_rest_api.root_resource_id
    path_part   = "hello" 
}

# We need to add a method to the route we created
resource "aws_api_gateway_method" "method_get" {
    rest_api_id       = aws_api_gateway_rest_api.my_rest_api.id 
    resource_id     = aws_api_gateway_resource.hello_route.id 
    authorization   = "NONE"
    http_method     = "GET"
}

# We need to integrate it with some backend (in our case it MOCK)
resource "aws_api_gateway_integration" "mock_integration" {
    rest_api_id = aws_api_gateway_rest_api.my_rest_api.id 
    resource_id = aws_api_gateway_resource.hello_route.id 
    http_method = aws_api_gateway_method.method_get.http_method
    type        = "MOCK"

    request_templates = {
        "application/json" = "{\"statusCode\": 200}"
    }
}

# Get the response from the method (GET) we created
resource "aws_api_gateway_method_response" "get_hello_response" {
    rest_api_id = aws_api_gateway_rest_api.my_rest_api.id 
    resource_id = aws_api_gateway_resource.hello_route.id 
    http_method = aws_api_gateway_method.method_get.http_method 
    status_code = "200" 

    response_models = {
        "application/json" = "Empty" 
    }
}

# We need to add integration response 
resource "aws_api_gateway_integration_response" "get_mock_response" {
    rest_api_id = aws_api_gateway_rest_api.my_rest_api.id 
    resource_id = aws_api_gateway_resource.hello_route.id 
    http_method = aws_api_gateway_method.method_get.http_method
    status_code = aws_api_gateway_method_response.get_hello_response.status_code 

    response_templates = {
        "application/json" = <<EOF
        {
            "message" : "Hello from MOCK!"
        }
        EOF
    }
}

# Deploy the API 
resource "aws_api_gateway_deployment" "mock_deployment" {
    depends_on  = [aws_api_gateway_integration.mock_integration]
    rest_api_id = aws_api_gateway_rest_api.my_rest_api.id 
    stage_name  = "dev"
}