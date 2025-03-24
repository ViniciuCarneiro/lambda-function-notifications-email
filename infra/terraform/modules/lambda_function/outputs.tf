output "lambda_function_name" {
  description = "Nome da função Lambda"
  value       = aws_lambda_function.this.function_name
}

output "lambda_function_arn" {
  description = "ARN da função Lambda"
  value       = aws_lambda_function.this.arn
}

output "lambda_role_name" {
  description = "Nome da role IAM associada à função Lambda"
  value       = aws_iam_role.lambda_role.name
}

output "lambda_role_arn" {
  description = "ARN da role IAM associada à função Lambda"
  value       = aws_iam_role.lambda_role.arn
}

output "s3_policy_name" {
  description = "Nome da política de acesso ao S3"
  value       = aws_iam_policy.lambda_s3_policy.name
}

output "sqs_policy_name" {
  description = "Nome da política de acesso ao SQS"
  value       = aws_iam_policy.lambda_sqs_policy.name
}

output "logs_policy_name" {
  description = "Nome da política de logs"
  value       = aws_iam_policy.lambda_logs_policy.name
}

output "sqs_event_source_mapping_id" {
  description = "ID do mapeamento de evento SQS para a função Lambda"
  value       = aws_lambda_event_source_mapping.this.id
}
