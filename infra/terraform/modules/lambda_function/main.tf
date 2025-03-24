terraform {
  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
  }
}

# Criação do arquivo ZIP contendo os arquivos da pasta src/arquivoslambda
data "archive_file" "lambda_code" {
  type        = "zip"
  source_dir = "${path.module}/../../../../src"
  output_path = "${path.module}/../../../../build/lambda_function.zip"
}

resource "aws_iam_role" "lambda_role" {
  name               = "${var.function_name}_role"
  assume_role_policy = file("${path.module}/../../iam_policies/lambda_assume_role_policy.json")
}

resource "aws_iam_policy" "lambda_s3_policy" {
  name        = "${var.function_name}_s3_policy"
  description = "Política de acesso ao S3 para a função Lambda"
    policy      = templatefile("${path.module}/../../iam_policies/s3_policy.json.tpl", {
    s3_bucket_name = var.s3_bucket_name
  })
}

resource "aws_iam_policy" "lambda_sqs_policy" {
  name        = "${var.function_name}_sqs_policy"
  description = "Política de acesso ao SQS para a função Lambda"
  policy      = templatefile("${path.module}/../../iam_policies/sqs_policy.json.tpl", {
    aws_region    = var.aws_region
    aws_account_id = var.aws_account_id
    sqs_queue_name = var.sqs_queue_name
  })
}

resource "aws_iam_policy" "lambda_logs_policy" {
  name        = "${var.function_name}_logs_policy"
  description = "Política de logs para a função Lambda"
  policy       = file("${path.module}/../../iam_policies/logs_policy.json")
}

resource "aws_iam_role_policy_attachment" "lambda_s3_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_s3_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_sqs_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_sqs_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_logs_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_logs_policy.arn
}

resource "aws_lambda_function" "this" {
  function_name    = var.function_name
  role             = aws_iam_role.lambda_role.arn
  handler          = var.handler
  runtime          = var.runtime
  filename         = data.archive_file.lambda_code.output_path
  source_code_hash = filebase64sha256(data.archive_file.lambda_code.output_path)
  timeout          = var.timeout
  environment {
    variables = var.environment_variables
  }
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.s3_bucket_name}"
}

resource "aws_lambda_permission" "allow_sqs" {
  statement_id  = "AllowExecutionFromSQS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "sqs.amazonaws.com"
  source_arn    = "arn:aws:sqs:${var.aws_region}:${var.aws_account_id}:${var.sqs_queue_name}"
}

resource "aws_lambda_event_source_mapping" "this" {
  event_source_arn = "arn:aws:sqs:${var.aws_region}:${var.aws_account_id}:${var.sqs_queue_name}"
  function_name    = aws_lambda_function.this.function_name
  enabled          = true
  batch_size       = 1
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 3
}
