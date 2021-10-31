terraform {
  backend "azurerm" {
    resource_group_name  = "tgedr0test0dev"
    storage_account_name = "tgedr0test0dev0base"
    container_name       = "terraform-remote-state"
    key                  = "group_users"
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {
}

variable "location" {
  type        = string
  default     = "West Europe"
}

variable "groups" {
  type        = list(string)
}

variable "generated_password" {
  type        = string
}

module "groups" {
  source = "./modules/azure/ad_groups"
  groups = var.groups
}

locals {
  users = [
    { display_name = "jonathan"
      password = var.generated_password
      user_principal_name = "jonat@tmptgedrgmail.onmicrosoft.com"
    },
    { display_name = "marie"
      password = var.generated_password
      user_principal_name = "marie@tmptgedrgmail.onmicrosoft.com"
    }
  ]
}

module "users" {
  source = "./modules/azure/ad_users"
  users = local.users
}

