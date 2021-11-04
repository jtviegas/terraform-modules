terraform {
  backend "azurerm" {
    resource_group_name  = "tgedr0test0dev"
    storage_account_name = "tgedr0test0dev0base"
    container_name       = "terraform-remote-state"
    key                  = "data_lake"
  }
}

provider "azurerm" {
  features {}
}

variable "location" {
  type        = string
  default     = "West Europe"
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

variable "data_lake_store_suffix" {
  type        = string
}

variable "data_lake_fs_name" {
  type        = string
}

variable "data_lake_paths" {
  type    = set(string)
}

module "data_lake" {
  source = "./modules/azure/data_lake"
  project = var.project
  solution = var.solution
  env = var.env
  data_lake_store_suffix = var.data_lake_store_suffix
  data_lake_fs_name = var.data_lake_fs_name
  data_lake_paths = var.data_lake_paths
}

output "data_lake_store_id" {
  value = module.data_lake.data_lake_store_id
}

output "data_lake_store_primary_location" {
  value = module.data_lake.data_lake_store_primary_location
}

output "data_lake_store_secondary_location" {
  value = module.data_lake.data_lake_store_secondary_location
}

output "data_lake_store_primary_access_key" {
  value = module.data_lake.data_lake_store_primary_access_key
}

output "data_lake_store_secondary_access_key" {
  value = module.data_lake.data_lake_store_secondary_access_key
}

output "data_lake_store_primary_connection_string" {
  value = module.data_lake.data_lake_store_primary_connection_string
}

output "data_lake_store_secondary_connection_string" {
  value = module.data_lake.data_lake_store_secondary_connection_string
}

output "data_lake_store_primary_blob_connection_string" {
  value = module.data_lake.data_lake_store_primary_blob_connection_string
}

output "data_lake_store_secondary_blob_connection_string" {
  value = module.data_lake.data_lake_store_secondary_blob_connection_string
}
