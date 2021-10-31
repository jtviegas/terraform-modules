terraform {
  backend "azurerm" {
    resource_group_name  = "tgedr0test0dev"
    storage_account_name = "tgedr0test0dev0base"
    container_name       = "terraform-remote-state"
    key                  = "group_membership"
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {
}

variable "operations_members" {
  type = list(string)
}

variable "operations_group" {
  type = string
}

module "operations_members" {
  source = "./modules/azure/ad_group_members"
  principal_names = var.operations_members
  group = var.operations_group
}

variable "sales_members" {
  type = list(string)
}

variable "sales_group" {
  type = string
}

module "sales_members" {
  source = "./modules/azure/ad_group_members"
  principal_names = var.sales_members
  group = var.sales_group
}