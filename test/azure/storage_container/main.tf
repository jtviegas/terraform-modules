terraform {
  backend "azurerm" {
    resource_group_name  = "tgedr0test0dev"
    storage_account_name = "tgedr0test0dev0base"
    container_name       = "terraform-remote-state"
    key                  = "storage_container"
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

variable "storage_account_suffix" {
  type        = string
}

variable "container_name" {
  type        = string
}

module "storage_container" {
  source = "./modules/azure/storage_container"
  project = var.project
  solution = var.solution
  env = var.env
  storage_account_suffix = var.storage_account_suffix
  container_name = var.container_name
}

output "storage_account_id" {
  value = module.storage_container.storage_account_id
}

output "storage_account_access_key" {
  value = module.storage_container.storage_account_access_key
}

output "storage_container_id" {
  value = module.storage_container.storage_container_id
}

