terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.74.0"
    }
  }
}

resource "azurerm_resource_group" "base_rg" {
  name     = "${var.project}_${var.solution}_${var.env}"
  location = var.location
}

# ARM_ACCESS_KEY
resource "azurerm_storage_account" "base" {
  name                     = "${var.project}0${var.solution}0base"
  resource_group_name      = azurerm_resource_group.base_rg.name
  location                 = azurerm_resource_group.base_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    env = var.env
    project = var.project
    solution = var.solution
  }
}

resource "azurerm_storage_container" "state" {
  name                  = "terraform-state"
  storage_account_name  = azurerm_storage_account.base.name
}

