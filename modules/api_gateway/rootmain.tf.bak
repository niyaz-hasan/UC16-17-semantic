module "search_api" {
  source     = "../modules/api_gateway"
  api_name   = var.api_name
  stage_name = var.api_stage_name
  tags       = var.tags

  routes = [
    {
      path                   = "/search"
      lambda_function_arn    = module.lambda_search.lambda_arn
      lambda_function_name   = module.lambda_search.lambda_name
    },
    {
      path                   = "/query"
      lambda_function_arn    = module.lambda_query.lambda_arn
      lambda_function_name   = module.lambda_query.lambda_name
    }
  ]

  depends_on = [
    module.lambda_search,
    module.lambda_query
  ]
}