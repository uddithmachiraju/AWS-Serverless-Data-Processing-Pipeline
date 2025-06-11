
provider "aws" {
	region = var.aws_region
}

# -------------------- Creating a REST API -----------------------#

resource "aws_api_gateway_rest_api" "books_api" {
	name = "a-book-library"
	description = "Basically a bunch of API enpoints for add, update, delete, and get books in a library database."
}

# ----------------------------- LAMBDA Function ----------------------------- #

resource "aws_lambda_function" "lambda_book" {
  function_name = "Lambda function for book"
  description = "Integrating my book api with lambda" 
  filename = "lambda_payload.zip"
  handler = "main.handler" 
  runtime = "python3.10"

  role = "Nothing" 
}

# -------------- Resources (all the endpoints) --------------- # 

# /books
resource "aws_api_gateway_resource" "books" {
	rest_api_id = aws_api_gateway_rest_api.books_api.id 
	parent_id = aws_api_gateway_rest_api.books_api.root_resource_id 
	path_part = "books" 
}

# /books/add
resource "aws_api_gateway_resource" "add" {
	rest_api_id = aws_api_gateway_rest_api.books_api.id 
	parent_id = aws_api_gateway_resource.books.id 
	path_part = "add" 
}

# books/update
resource "aws_api_gateway_resource" "update" {
	rest_api_id = aws_api_gateway_rest_api.books_api.id 
	parent_id = aws_api_gateway_resource.books.id 
	path_part = "update" 
}

# books/update/<id> 
resource "aws_api_gateway_resource" "update_id" {
	rest_api_id = aws_api_gateway_rest_api.books_api.id 
	parent_id = aws_api_gateway_resource.update.id 
	path_part = "{id}"
}

# books/delete
resource "aws_api_gateway_resource" "delete" {
	rest_api_id = aws_api_gateway_rest_api.books_api.id 
	parent_id = aws_api_gateway_resource.books.id 
	path_part = "delete"
}

# books/delete/<id> 
resource "aws_api_gateway_resource" "delete_id" {
	rest_api_id = aws_api_gateway_rest_api.books_api.id
	parent_id = aws_api_gateway_resource.delete.id
	path_part = "{id}" 
}

# ------------------ Add methods to the endpoints -------------------- #

# GET method for /books endpoint
resource "aws_api_gateway_method" "get_books" {
	rest_api_id = aws_api_gateway_rest_api.books_api.id 
	resource_id = aws_api_gateway_resource.books.id 
	authorization = "NONE"
	http_method = "GET" 
}

# POST method for /books/add endpoint 
resource "aws_api_gateway_method" "post_add" {
	rest_api_id = aws_api_gateway_rest_api.books_api.id 
	resource_id = aws_api_gateway_resource.add.id
	authorization = "NONE"
	http_method = "POST" 
}

# PUT method for /books/update/<id>
resource "aws_api_gateway_method" "put_books" {
	rest_api_id = aws_api_gateway_rest_api.books_api.id
	resource_id = aws_api_gateway_resource.update_id.id 
	authorization = "NONE" 
	http_method = "PUT"
}

# DELETE method of /books/delete/<id> 
resource "aws_api_gateway_method" "delete_books" {
	rest_api_id = aws_api_gateway_rest_api.books_api.id
	resource_id = aws_api_gateway_resource.delete_id.id 
	authorization = "NONE"
	http_method = "DELETE"
}

# ----------------------- Gateway Integration ------------------------- # 

# Integration from /books endpoint
resource "aws_api_gateway_integration" "mock_integration_get_books" {
  rest_api_id = aws_api_gateway_rest_api.books_api.id 
  resource_id = aws_api_gateway_resource.books.id 
  http_method = aws_api_gateway_method.get_books.http_method 
  type = "MOCK" 

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

# Intergration for /books/add endpoint
resource "aws_api_gateway_integration" "mock_integration_post_books" {
  rest_api_id = aws_api_gateway_rest_api.books_api.id 
  resource_id = aws_api_gateway_resource.add.id 
  http_method = aws_api_gateway_method.post_add.http_method 
  type = "MOCK" 

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

# Integration for /books/update/<id> 
resource "aws_api_gateway_integration" "mock_integration_update_book" {
  rest_api_id = aws_api_gateway_rest_api.books_api.id 
  resource_id = aws_api_gateway_resource.update_id.id 
  http_method = aws_api_gateway_method.put_books.http_method
  type = "MOCK" 

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

# Integration fro /books/delete/<id> 
resource "aws_api_gateway_integration" "mock_integration_delete_book" {
  rest_api_id = aws_api_gateway_rest_api.books_api.id 
  resource_id = aws_api_gateway_resource.delete_id.id 
  http_method = aws_api_gateway_method.delete_books.http_method 
  type = "MOCK" 

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

# ---------------------- Method Response ----------------------- # 

# method response for /books endpoint 
resource "aws_api_gateway_method_response" "get_books_response" {
  rest_api_id = aws_api_gateway_rest_api.books_api.id 
  resource_id = aws_api_gateway_resource.books.id 
  http_method = aws_api_gateway_method.get_books.http_method 
  status_code = "200" 

  response_models = {
    "application/json" = "Empty"
  }
}

# method reponse for /books/add endpoint 
resource "aws_api_gateway_method_response" "post_books_response" {
  rest_api_id = aws_api_gateway_rest_api.books_api.id 
  resource_id = aws_api_gateway_resource.add.id 
  http_method = aws_api_gateway_method.post_add.http_method 
  status_code = "200" 

  response_models = {
    "application/json" = "Empty"
  }
}

# method response for /books/update/<id>
resource "aws_api_gateway_method_response" "put_books_response" {
  rest_api_id = aws_api_gateway_rest_api.books_api.id 
  resource_id = aws_api_gateway_resource.update_id.id 
  http_method = aws_api_gateway_method.put_books.http_method 
  status_code = "200"

  response_models = {
    "application/json" = "Empty" 
  }
}

# method response for /books/delete/<id> 
resource "aws_api_gateway_method_response" "delete_books_response" {
  rest_api_id = aws_api_gateway_rest_api.books_api.id 
  resource_id = aws_api_gateway_resource.delete_id.id 
  http_method = aws_api_gateway_method.delete_books.http_method 
  status_code = "200" 

  response_models = {
    "application/json" = "Empty" 
  }
}

# ---------------------- Integration Response ------------------- # 
resource "aws_api_gateway_integration_response" "get_books_inte_response" {
  rest_api_id = aws_api_gateway_rest_api.books_api.id 
  resource_id = aws_api_gateway_resource.books.id 
  http_method = aws_api_gateway_method.get_books.http_method 
  status_code = aws_api_gateway_method_response.get_books_response.status_code

  response_templates = {
    "application/json" = <<EOF
  {
    "message": "This endpoint will get all the books in the database."
  }
  EOF
  }
}

resource "aws_api_gateway_integration_response" "post_books_inte_response" {
  rest_api_id = aws_api_gateway_rest_api.books_api.id 
  resource_id = aws_api_gateway_resource.add.id 
  http_method = aws_api_gateway_method.post_add.http_method
  status_code = aws_api_gateway_method_response.post_books_response.status_code 

  response_templates = {
    "application/json" = <<EOF
  {
    "message": "This endpoint will let you add a book into the database."
  }
  EOF
  }
}

resource "aws_api_gateway_integration_response" "put_book_inte_response" {
  rest_api_id = aws_api_gateway_rest_api.books_api.id 
  resource_id = aws_api_gateway_resource.update_id.id 
  http_method = aws_api_gateway_method.put_books.http_method
  status_code = aws_api_gateway_method_response.put_books_response.status_code

  response_templates = {
    "application/json" = <<EOF
  {
    "message": "This endpoint will let you update a book in the database."
  }
  EOF
  }
}

resource "aws_api_gateway_integration_response" "delete_book_inte_response" {
  rest_api_id = aws_api_gateway_rest_api.books_api.id 
  resource_id = aws_api_gateway_resource.delete_id.id 
  http_method = aws_api_gateway_method.delete_books.http_method
  status_code = aws_api_gateway_method_response.delete_books_response.status_code

  response_templates = {
    "application/json" = <<EOF
  {
    "message": "This endpoint will let you delete the book from the database."
  }
  EOF
  }
}

# -------------------- Deployment of teh REST API ---------------------- # 
resource "aws_api_gateway_deployment" "rest_api_deployment" {
  depends_on = [
    aws_api_gateway_integration_response.get_books_inte_response,
    aws_api_gateway_integration_response.post_books_inte_response,
    aws_api_gateway_integration_response.put_book_inte_response,
    aws_api_gateway_integration_response.delete_book_inte_response
  ]
  rest_api_id = aws_api_gateway_rest_api.books_api.id 
  stage_name = var.stage
}