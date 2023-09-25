output "all_developers_arns" {
  value = aws_iam_user.iam_user[*].arn
  description = "The ARNS of all the developers"
}