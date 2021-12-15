terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.74.0"
    }
  }
}

resource "azurerm_resource_group" "base_rg" {
  name     = "rg0${var.businessunit}0${var.solution}0${var.client}0${var.env}"
  location = var.location
}

# ARM_ACCESS_KEY
resource "azurerm_storage_account" "base" {
  name                     = "st0${var.name}0${var.env}0${var.geo}0${var.instance}"
  resource_group_name      = azurerm_resource_group.base_rg.name
  location                 = azurerm_resource_group.base_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    businessunit = var.businessunit
    solution = var.solution
    client = var.client
    environment = var.env
    geography = var.geo
  }
}

resource "azurerm_storage_container" "state" {
  name                  = "stc0tfstate0${var.instance}"
  storage_account_name  = azurerm_storage_account.base.name
}

