terraform {
  backend "azurerm" {
    resource_group_name  = "tgedr0test0dev"
    storage_account_name = "tgedr0test0dev0base"
    container_name       = "terraform-state"
    key                  = "storage"
  }
}

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


module "storage" {
  source = "./modules/azure/storage"
  project = var.project
  solution = var.solution
  env = var.env
}

output "storage_account_id" {
  value = module.storage.storage_account_id
}

output "storage_account_access_key" {
  value = module.storage.storage_account_access_key
}

output "storage_container_id" {
  value = module.storage.storage_container_id
}

