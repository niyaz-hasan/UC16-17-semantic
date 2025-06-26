raw_bucket_name         = "semantic-search-raw-ddd"
# processed_bucket_name   = "semantic-search-processed-ddd"

name = "demo"
vpc_cidr             = "10.0.0.0/16"
availability_zones   = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs  = ["10.0.6.0/24", "10.0.7.0/24"]
private_subnet_cidrs = ["10.0.4.0/24", "10.0.5.0/24"]
create_nat_gateway   = true

lambda_egress_rules = [
  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
]

rds_ingress_rules = []

rds_egress_rules = [
  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
]

db_name                 = "semanticdb"
db_username             = "postgres"
db_password             = "supersecretpassword"
db_instance_class       = "db.t3.micro"
db_secret_name          = "semantic-search-db-credentialsed"

lambda_code_bucket      = "lambda-code-bucket-ddd"
ingest_lambda_key       = "ingest.zip"
search_lambda_key       = "search.zip"
query_lambda_key        = "query.zip"

ingest_lambda_name      = "semantic-ingest"
search_lambda_name      = "semantic-search"
query_lambda_name       = "semantic-query"
# ingest_lambda_handler   = "main.lambda.handler"
# search_lambda_handler   = "search_lambda.handler"


lambda_runtime          = "python3.11"
lambda_role_name        = "semantic-lambda-role"
lambda_policy_arns      = [
  "arn:aws:iam::aws:policy/AWSLambdaExecute",
  "arn:aws:iam::aws:policy/SecretsManagerReadWrite",
  "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
  "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole",
  "arn:aws:iam::aws:policy/AmazonBedrockFullAccess"
]

api_name                = "semantic-search-api"

tags = {
  Project = "SemanticSearch"
  Env   = "dev"
}