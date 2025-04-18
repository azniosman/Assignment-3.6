variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-1"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "hello-world-lambda"
}

variable "lambda_runtime" {
  description = "Runtime for the Lambda function"
  type        = string
  default     = "python3.9"
}

variable "lambda_handler" {
  description = "Handler for the Lambda function"
  type        = string
  default     = "lambda_function.lambda_handler"
}
