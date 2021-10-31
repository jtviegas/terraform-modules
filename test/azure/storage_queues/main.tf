terraform {
  backend "azurerm" {
    resource_group_name  = "tgedr0test0dev"
    storage_account_name = "tgedr0test0dev0base"
    container_name       = "terraform-remote-state"
    key                  = "storage_queues"
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

variable "queues" {
  type        = set(string)
}

module "storage_queues" {
  source = "./modules/azure/storage_queues"
  project = var.project
  solution = var.solution
  env = var.env
  storage_account_suffix = var.storage_account_suffix
  queues = var.queues
}

output "storage_account_id" {
  value = module.storage_queues.storage_account_id
}

output "storage_account_access_key" {
  value = module.storage_queues.storage_account_access_key
}

output "queue_ids" {
  value = module.storage_queues.queue_ids
}

