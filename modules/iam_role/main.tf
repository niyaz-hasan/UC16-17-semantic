resource "aws_iam_role" "this" {
  name = var.role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  count      = length(var.policy_arns)
  policy_arn = var.policy_arns[count.index]
  role       = aws_iam_role.this.name
}

resource "aws_iam_role_policy" "custom_inline" {
  count = var.inline_policy != null ? 1 : 0

  name = "${var.role_name}-inline"
  role = aws_iam_role.this.id

  policy = var.inline_policy
}

# output "iam_role_arn" {
#   value = aws_iam_role.this.arn
# }