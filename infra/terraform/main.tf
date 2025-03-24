provider "aws" {
  region = var.aws_region
}

module "lambda_function" {
  source        = "./modules/lambda_function"
  function_name = var.function_name
  handler       = var.handler
  runtime       = var.runtime
  s3_bucket_name = var.s3_bucket_name
  aws_region    = var.aws_region
  aws_account_id = var.aws_account_id
  sqs_queue_name = var.sqs_queue_name
  environment_variables = var.environment_variables
  timeout = 5
}
