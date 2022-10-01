provider "aws" {
  region  = var.region
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

module "ops_user" {
  source = "./modules/aws/ops-user"
  group_name = var.group_name
  user_name = var.user_name
}

output "password" {
  value = module.ops_user.password
}

output "access_key" {
  value = module.ops_user.access_key
  sensitive = true
}
