resource "aws_lambda_function" "this" {
  function_name = var.function_name
  s3_bucket     = var.s3_bucket
  s3_key        = var.s3_key
  handler       = var.handler
  # handler       = main.lambda_handler
  runtime       = var.runtime
  role          = var.role_arn
  timeout       = var.timeout
  memory_size   = var.memory_size

  environment {
    variables = var.environment_vars
  }

  vpc_config {
    subnet_ids         = var.vpc_config.subnet_ids
    security_group_ids = var.vpc_config.security_group_ids
  }

  # dynamic "layers" {
  #   for_each = var.layers
  #   content {
  #     arn = layers.value
  #   }
  # }
  layers = var.layers

  reserved_concurrent_executions = var.reserved_concurrent_executions

  tags = var.tags
}

resource "aws_lambda_alias" "live" {
  name             = "live"
  function_name    = aws_lambda_function.this.function_name
  function_version = aws_lambda_function.this.version
  depends_on       = [aws_lambda_function.this]
}