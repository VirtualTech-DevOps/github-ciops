output "role" {
  description = ""
  value       = aws_iam_role.oidc.arn
}

output "region" {
  description = ""
  value       = local.aws_region
}
