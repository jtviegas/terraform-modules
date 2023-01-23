provider "azurerm" {
  features {}
}


variable "resource_group" { type = string }
variable "solution" { type = string }
variable "env" { type = string }
variable "data_lake_storage_account" { type = string }
variable "data_lake_fs_name" { type = string }
variable "data_lake_path" { type    = string }
variable "data_lake_privpath" { type    = string }
variable "owner_id" { type    = string }
variable "guest_id" { type    = string }
variable "owner_group_id" { type    = string }
variable "guest_group_id" { type    = string }

module "data_lake" {
  source = "./modules/azure/datalake_acl"
  resource_group = var.resource_group
  solution = var.solution
  env = var.env
  data_lake_storage_account = var.data_lake_storage_account
  data_lake_fs_name = var.data_lake_fs_name
  data_lake_path = var.data_lake_path
  data_lake_privpath = var.data_lake_privpath
  owner_id = var.owner_id
  guest_id = var.guest_id
  owner_group_id = var.owner_group_id
  guest_group_id = var.guest_group_id
}
