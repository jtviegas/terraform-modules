terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_iam_user" "user_name" {
  name = var.user_name
  force_destroy = true
}

resource "aws_iam_user_login_profile" "user_profile" {
  user    = aws_iam_user.user_name.name
}

resource "aws_iam_user_group_membership" "user_group" {
  user    = aws_iam_user.user_name.name
  groups = [ var.group_name, ]
}

resource "aws_iam_access_key" "user_access_key" {
  user    = aws_iam_user.user_name.name
}
