#resource "aws_lambda_layer_version" "semantic_layer" {
#  filename            = var.semantic_layer_zip
#  layer_name          = "semantic_layer"
#  compatible_runtimes = ["python3.9"]
#}


resource "aws_lambda_function" "this" {
  filename         = var.lambda_zip
  function_name = var.function_name
  handler       = var.handler
  # handler       = main.lambda_handler
  runtime       = var.runtime
  role          = var.role_arn
  timeout       = var.timeout
  memory_size   = var.memory_size
  source_code_hash = filebase64sha256(var.lambda_zip)

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
  layers = ["arn:aws:lambda:us-east-1:975049998898:layer:semantic_layer:2"]

  reserved_concurrent_executions = var.reserved_concurrent_executions

  tags = var.tags
}

resource "aws_lambda_alias" "live" {
  name             = "live"
  function_name    = aws_lambda_function.this.function_name
  function_version = aws_lambda_function.this.version
  depends_on       = [aws_lambda_function.this]
}