variable "function_name" { 
  type = string 
}
variable "s3_bucket" { 
  type = string 
}
variable "s3_key" { 
  type = string 
}
variable "handler" { 
  type = string
  default = "main.lambda_handler" 
}
variable "runtime" { 
  type = string 
}
variable "role_arn" { 
  type = string
}

variable "environment_vars" {
  type = map(string)
}

variable "vpc_config" {
  type = object({
    subnet_ids         = list(string)
    security_group_ids = list(string)
  })
}

variable "tags" { 
  type = map(string) 
}

variable "layers" {
  type    = list(string)
  default = []
}

variable "reserved_concurrent_executions" {
  type    = number
  default = -1
}

variable "timeout" {
  type    = number
  default = 120
}

variable "memory_size" {
  type    = number
  default = 512
}