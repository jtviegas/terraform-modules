provider "azurerm" {
  features {}
}

variable "project" {
  type    = string
}

variable "solution" {
  type    = string
}

variable "env" {
  type    = string
}

module "base" {
  source = "./modules/azure/base"
  project = var.project
  solution = var.solution
  env = var.env
}

output "base_state_storage_account_id" {
  value = module.base.storage_account_id
}

output "base_state_storage_account_access_key" {
  value = module.base.storage_account_access_key
}

output "base_state_storage_container_id" {
  value = module.base.storage_container_id
}

output "resource_group_id" {
  value = module.base.resource_group_id
}