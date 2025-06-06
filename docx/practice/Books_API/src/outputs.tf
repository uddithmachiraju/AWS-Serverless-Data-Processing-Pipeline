
output "rest_api_url" {
  description = "Base Invoke URL of the REST API"
  value       = "https://${aws_api_gateway_rest_api.books_api.id}.execute-api.${var.aws_region}.amazonaws.com/${var.stage}"
}
