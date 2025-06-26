variable "raw_bucket_name" { 
  type = string 
}
# variable "processed_bucket_name" { 
#   type = string 
# }

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "create_nat_gateway" {
  description = "Whether to create a NAT Gateway"
  type        = bool
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

variable "lambda_code_bucket" { 
  type = string 
}
variable "ingest_lambda_key" { 
  type = string 
}
variable "search_lambda_key" { 
  type = string 
}

variable "query_lambda_key" { 
  type = string 
}


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
variable "lambda_role_name" { 
  type = string 
}
variable "lambda_policy_arns" { 
  type = list(string) 
}

variable "api_name" { 
  type = string 
}

variable "tags" { 
  type = map(string) 
}

variable "lambda_egress_rules" {
  description = "Egress rules for Lambda SG"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = optional(list(string))
  }))
}


variable "rds_ingress_rules" {
  description = "Ingress rules for RDS SG"
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    security_groups = optional(list(string))
    cidr_blocks     = optional(list(string))
  }))
}

variable "rds_egress_rules" {
  description = "Egress rules for RDS SG"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = optional(list(string))
  }))
}
variable "qurey_layers" {
  description = "List of Lambda layer ARNs for the query lambda."
  type        = list(string)
  default     = []
}
variable "api_stage_name" {
  type = string
  default = "$default"
}