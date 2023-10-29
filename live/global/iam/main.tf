provider "aws" {
  region = "us-east-2"
}

resource "aws_iam_user" "iam_user" {
  for_each = toset(var.developers)
  name = each.value
}

resource "aws_iam_policy" "cloudwatch_read_only" {
  name = "cloudwatch-read-only"
  policy = data.aws_iam_policy_document.cloudwatch_read_only.json
}

 data "aws_iam_policy_document" "cloudwatch_read_only"{
    statement{
      effect = "Allow"
      actions = [
        "cloudwatch:Describe*",
        "cloudwatch:Get*",
        "cloudwatch:List*"
      ]
      resources = [ "*" ]
    }
  }

  resource "aws_iam_policy" "cloudwatch_full_access" {
    name = "cloudwatch_full_access"
    policy = data.aws_iam_policy_document.cloudwatch_full_access.json
  }
  data "aws_iam_policy_document" "cloudwatch_full_access" {
    statement {
      effect = "Allow"
      actions = [
        "cloudwatch:*"
      ]
      resources = ["*"]
    }
  }

  resource "aws_iam_user_policy_attachment" "hari_cloudwatch_full_access" {
    count = var.give_hari_cloudwatch_full_access ? 1 : 0
    user = aws_iam_user.iam_user["Hari"].name
    policy_arn = aws_iam_policy.cloudwatch_full_access.arn
  }

  resource "aws_iam_user_policy_attachment" "hari_cloudwatch_read_only_access" {
    count = var.give_hari_cloudwatch_full_access ? 0 : 1
    user = aws_iam_user.iam_user["Hari"].name
    policy_arn = aws_iam_policy.cloudwatch_read_only.arn
  }