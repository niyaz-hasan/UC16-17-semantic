module "s3_bucket" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
  tags        = var.tags
}


module "vpc" {
  source = "./modules/vpc"
  name           = var.name
  vpc_cidr_block = var.vpc_cidr_block

  depends_on = [
    module.s3_bucket
  ]
}


#module "lambda_sg" {
#  source        = "./modules/security_group"
#  name          = "lambda-sg"
#  description   = "SG for Lambda"
#  vpc_id        = module.vpc.vpc_id
#  depends_on = [
#    module.s3_bucket,
#    module.vpc
#  ]
#
#}

module "rds_sg" {
  source        = "./modules/security_group"
  vpc_id        = module.vpc.vpc_id
  depends_on = [
    module.s3_bucket,
    module.vpc
  ]
}

module "rds_postgres" {
  source            = "./modules/rds_postgresql"
  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
  db_instance_class = var.db_instance_class
  subnet_ids        = module.vpc.private_subnets
  vpc_security_group_ids = [module.rds_sg.rds_security_group_aurora_id] 
  tags              = var.tags
  depends_on = [
    module.s3_bucket,
    module.vpc,
    module.rds_sg
  ]
}

module "db_secret" {
  source      = "./modules/secrets_manager"
  secret_name = var.db_secret_name
  secret_value = jsonencode({
    username = var.db_username
    password = var.db_password
  })
  tags = var.tags
}



module "lambda_iam_role" {
  source      = "./modules/iam_role"
  bucket_name = module.s3_bucket.bucket_name
}

data "archive_file" "lambda_zip_ingest" {
  type        = "zip"
  source_file = "${path.module}/lambda_ingest/main.py"
  output_path = "${path.module}/lambda_ingest/main.zip"
}

data "archive_file" "lambda_zip_query" {
  type        = "zip"
  source_file = "${path.module}/lambda_query/main.py"
  output_path = "${path.module}/lambda_query/main.zip"
}

module "lambda_ingest" {
  source          = "./modules/lambda"
  function_name   = var.ingest_lambda_name
  lambda_zip      = data.archive_file.lambda_zip_ingest.output_path
 # semantic_layer_zip     = "${path.module}/lambda_layer.zip"
  # handler         = var.ingest_lambda_handler
  runtime         = var.lambda_runtime
  role_arn        = module.lambda_iam_role.iam_role_arn
  environment_vars = {
    DB_SECRET_NAME = var.db_secret_name
    RAW_BUCKET     = var.bucket_name
  }
  vpc_config = {
    subnet_ids         = module.vpc.private_subnets
    security_group_ids = [module.rds_sg.rds_security_group_aurora_id]
  }
  tags = var.tags

  depends_on = [
    module.s3_bucket,
    module.vpc,
    module.rds_sg,
    module.lambda_iam_role,
    module.db_secret
  ]

}

#module "lambda_search" {
#  source          = "./modules/lambda"
#  function_name   = var.search_lambda_name
#  s3_bucket       = var.lambda_code_bucket
#  s3_key          = var.search_lambda_key
#  # handler         = var.search_lambda_handler
#  runtime         = var.lambda_runtime
#  role_arn        = module.lambda_iam_role.iam_role_arn
#  environment_vars = {
#    DB_SECRET_NAME = var.db_secret_name
#  }
#  vpc_config = {
#    subnet_ids         = module.vpc.private_subnets
#    security_group_ids = [module.lambda_sg.security_group_id] 
#  }
#  tags = var.tags
#
#  depends_on = [
#    module.s3_bucket,
#    module.vpc,
#    module.lambda_sg,
#    module.lambda_iam_role,
#    module.db_secret
#  ]
#
#
#}
#
#module "lambda_query" {
#  source          = "./modules/lambda"
#  function_name   = var.query_lambda_name
#  s3_bucket       = var.lambda_code_bucket
#  s3_key          = var.query_lambda_key
#  # handler         = var.search_lambda_handler
#  runtime         = var.lambda_runtime
#  role_arn        = module.lambda_iam_role.iam_role_arn
#  # layers = var.qurey_layers
#  environment_vars = {
#    DB_SECRET_NAME = var.db_secret_name
#  }
#  vpc_config = {
#    subnet_ids         = module.vpc.private_subnet_ids
#    security_group_ids = [module.lambda_sg.security_group_id] 
#  }
#  tags = var.tags
#
#  depends_on = [
#    module.s3_bucket,
#    module.vpc,
#    module.lambda_sg,
#    module.lambda_iam_role,
#    module.db_secret
#  ]
#}

#module "search_api" {
#  source     = "./modules/api_gateway"
#  api_name   = var.api_name
#  stage_name = var.api_stage_name
#  tags       = var.tags
#
#  routes = [
#    {
#      path                   = "/search"
#      lambda_function_arn    = module.lambda_search.lambda_arn
#      lambda_function_name   = module.lambda_search.lambda_name
#    },
#    {
#      path                   = "/query"
#      lambda_function_arn    = module.lambda_query.lambda_arn
#      lambda_function_name   = module.lambda_query.lambda_name
#    }
#  ]
#
#  depends_on = [
#    module.lambda_search,
#    module.lambda_query
#  ]
#}


# Allow S3 to invoke the Lambda
resource "aws_lambda_permission" "allow_s3_to_invoke_lambda" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_ingest.lambda_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.bucket_name}"
}

#resource "aws_s3_bucket_notification" "lambda_trigger" {
#  bucket = var.bucket_name
#
#  lambda_function {
#    lambda_function_arn = module.lambda_ingest.lambda_arn
#    events              = ["s3:ObjectCreated:*"]
#    filter_suffix       = ".pdf"
#  }
#
#  lambda_function {
#    lambda_function_arn = module.lambda_ingest.lambda_arn 
#    events              = ["s3:ObjectCreated:*"]
#    filter_suffix       = ".txt"
#  }
#
#  depends_on = [
#    aws_lambda_permission.allow_s3_to_invoke_lambda,
#    module.lambda_ingest
#  ]
#}