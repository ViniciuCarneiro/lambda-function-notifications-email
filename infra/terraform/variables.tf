variable "aws_region" {
  description = "A AWS region to deploy resources"
  type        = string
}

variable "function_name" {
  description = "Nome da função Lambda"
  type        = string
}

variable "handler" {
  description = "Handler da função Lambda"
  type        = string
}

variable "runtime" {
  description = "Tempo de execução da função Lambda"
  type        = string
}

variable "filename" {
  description = "Caminho para o arquivo ZIP da função Lambda"
  type        = string
}

variable "s3_bucket_name" {
  description = "Nome do bucket S3"
  type        = string
}

variable "aws_account_id" {
  description = "ID da conta AWS"
  type        = string
}

variable "sqs_queue_name" {
  description = "Nome da fila SQS"
  type        = string
}

variable "environment_variables" {
  description = "Variáveis de ambiente para a função Lambda"
  type        = map(string)
}

variable "timeout" {
  description = "Tempo de timeout do lambda em segundos."
  type        = number
}