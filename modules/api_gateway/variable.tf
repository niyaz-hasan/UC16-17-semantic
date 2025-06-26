# variable "api_name" { 
#     type = string 
# }
# variable "stage_name" { 
#     type = string
#     default = "$default" 
# }
# variable "lambda_function_arn" { 
#     type = string 
# }
# variable "tags" { 
#     type = map(string) 
# }

# variable "lambda_function_name" {
#   type = string
# }
######
variable "api_name" {
  type = string
}

variable "stage_name" {
  type    = string
  default = "$default"
}

variable "routes" {
  description = "List of route definitions: each with lambda_arn, lambda_name, and path"
  type = list(object({
    path              = string
    lambda_function_arn  = string
    lambda_function_name = string
  }))
}

variable "tags" {
  type = map(string)
}