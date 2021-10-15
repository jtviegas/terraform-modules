terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.74.0"
    }
  }
}

data "azurerm_resource_group" "base_rg" {
  name = "${var.project}0${var.solution}0${var.env}"
}

resource "azurerm_storage_account" "storage" {
  name                     = "${var.project}0${var.solution}0${var.env}0storage"
  resource_group_name      = data.azurerm_resource_group.base_rg.name
  location                 = data.azurerm_resource_group.base_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    env = var.env
    project = var.project
    solution = var.solution
  }
}

resource "azurerm_storage_container" "datalake" {
  name                  = "datalake"
  storage_account_name  = azurerm_storage_account.storage.name
}

