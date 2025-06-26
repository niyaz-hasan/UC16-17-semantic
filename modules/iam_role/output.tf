output "iam_role_arn" {
  description = "ARN of the IAM role"
  value       = aws_iam_role.lambda_exec.arn
}

output "iam_role_name" {
  description = "Name of the IAM role"
  value       = aws_iam_role.lambda_exec.name
}