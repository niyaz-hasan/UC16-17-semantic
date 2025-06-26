output "rds_security_group_aurora_id" {
  description = "Security group ID for the RDS"
  value       = aws_security_group.rds_sg.id 
}

