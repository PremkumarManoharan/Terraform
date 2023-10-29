output "all_users" {
  value = values(aws_iam_user.iam_user)[*].arn
}