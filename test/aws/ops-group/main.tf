variable "group_name" {
  type      = string
}

variable "region" {
  type    = string
}

provider "aws" {
  region  = var.region
}

module "ops_group" {
  source = "./modules/aws/ops-group"
  group_name = var.group_name
}

output "group_id" {
  value = module.ops_group.group_id
}

output "group_arn" {
  value = module.ops_group.group_arn
}

output "role_id" {
  value = module.ops_group.role_id
}

output "role_arn" {
  value = module.ops_group.role_arn
}