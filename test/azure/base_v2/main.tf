provider "azurerm" {
  features {}
}

variable "businessunit" {
  type        = string
}
variable "solution" {
  type        = string
}
variable "client" {
  type        = string
}
variable "env" {
  type        = string
}
variable "name" {
  type        = string
}
variable "instance" {
  type        = string
}


module "base" {
  source = "./modules/azure/base_v2"
  businessunit = var.businessunit
  solution = var.solution
  client = var.client
  env = var.env
  name = var.name
  instance = var.instance
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