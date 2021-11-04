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

resource "azuread_user" "users" {
  for_each = {for u in var.users: u.display_name => u}
  display_name        = each.value.display_name
  password            = each.value.password
  user_principal_name = each.value.user_principal_name
}
