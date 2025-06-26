resource "aws_apigatewayv2_api" "this" {
  name          = var.api_name
  protocol_type = "HTTP"
  tags          = var.tags
}

resource "aws_apigatewayv2_stage" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = var.stage_name
  auto_deploy = true
}

# Loop through each route
resource "aws_apigatewayv2_integration" "this" {
  for_each = { for route in var.routes : route.path => route }

  api_id             = aws_apigatewayv2_api.this.id
  integration_type   = "AWS_PROXY"
  integration_uri    = each.value.lambda_function_arn
  integration_method = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "this" {
  for_each = aws_apigatewayv2_integration.this

  api_id    = aws_apigatewayv2_api.this.id
  route_key = "POST ${each.key}"
  target    = "integrations/${each.value.id}"
}

resource "aws_lambda_permission" "apigw_invoke" {
  for_each = { for route in var.routes : route.path => route }

  statement_id  = "AllowInvoke_${replace(each.key, "/", "_")}"
  action        = "lambda:InvokeFunction"
  function_name = each.value.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_apigatewayv2_api.this.id}/*/*"
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

