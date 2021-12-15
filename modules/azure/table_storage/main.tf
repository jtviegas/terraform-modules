terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.74.0"
    }
  }
}

data "azurerm_resource_group" "base_rg" {
  name = "rg0${var.businessunit}0${var.solution}0${var.client}0${var.env}"
}

resource "azurerm_storage_account" "storageaccount_for_table" {
  name                     = "st0${var.name}0${var.env}0${var.geo}0${var.instance}"
  resource_group_name      = data.azurerm_resource_group.base_rg.name
  location                 = data.azurerm_resource_group.base_rg.location
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

resource "azurerm_storage_table" "storage_table" {
  name                  = "stt0${var.name}0${var.env}0${var.geo}0${var.instance}"
  storage_account_name  = azurerm_storage_account.storageaccount_for_table.name
}




