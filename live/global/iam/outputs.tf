output "all_users" {
  value = values(aws_iam_user.iam_user)[*].arn
}
output "hari_cloudwatch_policy_arn" {
  value = one(concat(aws_iam_user_policy_attachment.hari_cloudwatch_full_access[*].policy_arn, aws_iam_user_policy_attachment.hari_cloudwatch_read_only_access[*].policy_arn))
}