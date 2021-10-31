terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "=2.8.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.74.0"
    }
  }
}

data "azuread_client_config" "current" {}

resource "azuread_group" "groups" {
  for_each = toset(var.groups)
  display_name     = each.value
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
}

