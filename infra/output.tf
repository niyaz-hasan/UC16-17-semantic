output "raw_bucket_name" {
  value = module.raw_s3_bucket.bucket_name
}

output "db_endpoint" {
  value = module.rds_postgres.rds_endpoint
}

output "lambda_search_url" {
  value = module.search_api.api_url
}

output "db_secret_arn" {
  value = module.db_secret.secret_arn
}

output "lambda_ingest_name" {
  value = module.lambda_ingest.lambda_name
}