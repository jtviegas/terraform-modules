terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "=2.10.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.74.0"
    }
  }
#  backend "azurerm" {
#    resource_group_name  = "tgedr0test0dev"
#    storage_account_name = "tgedr0test0dev0base"
#    container_name       = "terraform-remote-state"
#    key                  = "event_hub"
#  }
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


data "azuread_service_principal" "sp_eventhubs" {
  display_name = "Microsoft.EventHubs"
}

