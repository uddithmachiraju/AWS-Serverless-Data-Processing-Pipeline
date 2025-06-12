# Create an IAM role for the lambda to run the things
resource "aws_iam_role" "lambda_exec" {
  name = "lambda-exec-role"

  # Temporarly use this role for the lambda (ROlE) 
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow" 
          Principal = {
            Service = "lambda.amazonaws.com" # only for lambda
          }
        }
      ]
    }
  )

}

# Add the policies to the role we created (basically CloudWatch)
resource "aws_iam_role_policy_attachment" "lambda_execution_policy" {
  role = aws_iam_role.lambda_exec.name 
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
