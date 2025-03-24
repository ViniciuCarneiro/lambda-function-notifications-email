# Definições específicas para a função Lambda
function_name        = "lambda-name"
handler             = "index.handler"
runtime             = "nodejs22.x"
filename            = "lambda.zip"

# Informações da AWS
aws_region          = "REGIAO_AWS"
aws_account_id     = "ID_CONTA_AWS"
s3_bucket_name     = "NOME_BUCKET_ASSOCIADO"
sqs_queue_name     = "NOME_FILA_ASSOCIADA"

# Variáveis de ambiente para a função Lambda
environment_variables = {
  var1 = "var1"
}

timeout     = 5
