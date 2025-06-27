bucket_name         = "semantic-search-raw-ddd"
# processed_bucket_name   = "semantic-search-processed-ddd"

name = "demo"
vpc_cidr_block          = "10.0.0.0/16"
db_name                 = "semanticdb"
db_username             = "postgres"
db_password             = "II8xr9hqEHBDa3c"
db_instance_class       = "db.t3.micro"
db_secret_name          = "semantic-search-db-credentialsed"

lambda_code_bucket      = "lambda-code-bucket-ddd"
ingest_lambda_key       = "ingest.zip"
search_lambda_key       = "search.zip"
query_lambda_key        = "query.zip"
aws_region              = "us-east-1"

ingest_lambda_name      = "semantic-ingest"
search_lambda_name      = "semantic-search"
query_lambda_name       = "semantic-query"
# ingest_lambda_handler   = "main.lambda.handler"
# search_lambda_handler   = "search_lambda.handler"


lambda_runtime          = "python3.12"
lambda_role_name        = "semantic-lambda-role"
#api_name                = "semantic-search-api"

tags = {
  Project = "SemanticSearch"
  Env   = "dev"
}