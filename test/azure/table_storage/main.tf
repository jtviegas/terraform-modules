terraform {
  backend "azurerm" {
    resource_group_name  = "rg0eng0tfmod0team0dev"
    storage_account_name = "st0base0dev0weu0001"
    container_name       = "stc0tfstate0001"
    key                  = "table0storage"
  }
}

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

module "table_storage" {
  source = "./modules/azure/table_storage"
  businessunit = var.businessunit
  solution = var.solution
  client = var.client
  env = var.env
  name = var.name
  instance = var.instance
}

output "storage_account_id" {
  value = module.table_storage.storage_account_id
}

output "storage_account_access_key" {
  value = module.table_storage.storage_account_access_key
}

output "storage_table_id" {
  value = module.table_storage.storage_table_id
}
