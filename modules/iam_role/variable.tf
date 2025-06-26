variable "role_name" { 
    type = string 
}
variable "policy_arns" { 
    type = list(string) 
}
variable "tags" { 
    type = map(string) 
}
variable "inline_policy" {
  description = "IAM inline policy in JSON format"
  type        = string
  default     = null
}