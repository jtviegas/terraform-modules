provider "azurerm" {
  features {}
}

variable "businessunit" { type        = string }
variable "solution" { type        = string }
variable "solution_short" { type        = string }
variable "component" { type        = string }
variable "client" { type        = string }
variable "location" { type        = string }
variable "geo" { type        = string }
variable "env" { type        = string }
variable "resource_group" { type        = string }
variable "configuration_store_account" { type        = string }
variable "tfstate_storage_container" { type        = string }
module "base" {
  source = "./modules/azure/base"
  businessunit = var.businessunit
  solution = var.solution
  solution_short = var.solution_short
  component = var.component
  client = var.client
  location = var.location
  geo = var.geo
  env = var.env
  resource_group = var.resource_group
  configuration_store_account = var.configuration_store_account
  tfstate_storage_container = var.tfstate_storage_container
}

output "config_storage_account_id" {
  value = module.base.storage_account_id
}
output "config_storage_account_name" {
  value = module.base.storage_account_name
}
output "config_storage_account_access_key" {
  value = module.base.storage_account_access_key
  sensitive = true
}
output "tfstate_storage_container_id" {
  value = module.base.storage_container_id
}
output "tfstate_storage_container_name" {
  value = module.base.storage_container_name
}
output "resource_group_id" {
  value = module.base.resource_group_id
}
output "resource_group_name" {
  value = module.base.resource_group_name
}