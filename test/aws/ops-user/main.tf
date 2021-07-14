variable "user_public_key" {
  type      = string
}

variable "user_name" {
  type      = string
}

variable "group_name" {
  type      = string
}

variable "region" {
  type    = string
}

provider "aws" {
  region  = var.region
}

module "ops_user" {
  source = "./modules/aws/ops-user"
  group_name = var.group_name
  user_name = var.user_name
  user_public_key = var.user_public_key
}

output "password" {
  value = module.ops_user.password
}
