variable "bucket_name" { 
  type = string 
}
# variable "processed_bucket_name" { 
#   type = string 
# }

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "aws_region" {
  description = "region name"
  type        = string
}

variable "name" {
  description = "VPC name"
  type        = string
}

variable "db_name" { 
  type = string 
}
variable "db_username" { 
  type = string 
}
variable "db_password" { 
  type = string 
  sensitive = true 
}
variable "db_instance_class" { 
  type = string 
}
variable "db_secret_name" { 
  type = string 
}

#variable "lambda_code_bucket" { 
#  type = string 
#}
#variable "ingest_lambda_key" { 
#  type = string 
#}
#variable "search_lambda_key" { 
#  type = string 
#}
#
#variable "query_lambda_key" { 
#  type = string 
#}


variable "ingest_lambda_name" { 
  type = string 
}
variable "search_lambda_name" { 
  type = string 
}

variable "query_lambda_name" { 
  type = string 
}
# variable "ingest_lambda_handler" { 
#   type = string 
# }
# variable "search_lambda_handler" { 
#   type = string 
# }

variable "lambda_runtime" { 
  type = string 
}


variable "tags" { 
  type = map(string) 
}


variable "qurey_layers" {
  description = "List of Lambda layer ARNs for the query lambda."
  type        = list(string)
  default     = []
}


#variable "api_stage_name" {
#  type = string
#  default = "$default"
#}