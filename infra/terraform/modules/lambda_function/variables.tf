# Nome único para a função Lambda
variable "function_name" {
  description = "Nome único para a função Lambda."
  type        = string
}

variable "timeout" {
  description = "Tempo de timeout do lambda em segundos."
  type        = number
}

# Handler da função Lambda (ponto de entrada no código)
variable "handler" {
  description = "Handler da função Lambda."
  type        = string
}

# Ambiente de execução da função Lambda (por exemplo, nodejs14.x, python3.8)
variable "runtime" {
  description = "Ambiente de execução da função Lambda."
  type        = string
}

# Nome do bucket do Amazon S3
variable "s3_bucket_name" {
  description = "Nome do bucket do Amazon S3."
  type        = string
}

# Nome da fila do Amazon SQS
variable "sqs_queue_name" {
  description = "Nome da fila do Amazon SQS."
  type        = string
}

# ID da conta AWS
variable "aws_account_id" {
  description = "ID da conta AWS."
  type        = string
}

# Região AWS
variable "aws_region" {
  description = "Região AWS."
  type        = string
}

# Variáveis de ambiente para a função Lambda
variable "environment_variables" {
  description = "Mapa de variáveis de ambiente a serem passadas para a função Lambda."
  type        = map(string)
  default     = {}
}
