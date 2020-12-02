terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_iam_user" "user_name" {
  name = var.user_name
}

resource "aws_iam_user_login_profile" "user_profile" {
  user    = aws_iam_user.user_name.name
  pgp_key = var.user_public_key
}

resource "aws_iam_user_group_membership" "user_group" {
  user    = aws_iam_user.user_name.name
  groups = [ var.group_name, ]
}

