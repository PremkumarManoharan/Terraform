provider "aws" {
  region = "us-east-2"
}

resource "aws_iam_user" "iam_user" {
  count = length(var.developers)
  name = var.developers[count.index]
}