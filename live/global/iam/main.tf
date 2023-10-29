provider "aws" {
  region = "us-east-2"
}

resource "aws_iam_user" "iam_user" {
  for_each = toset(var.developers)
  name = each.value
}