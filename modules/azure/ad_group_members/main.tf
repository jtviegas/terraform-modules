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

data "azuread_users" "users" {
  user_principal_names = var.principal_names
}

data "azuread_group" "group" {
  display_name     = var.group
  security_enabled = true
}

resource "azuread_group_member" "group_members" {
  for_each = toset(data.azuread_users.users.object_ids)
  group_object_id  = data.azuread_group.group.object_id
  member_object_id = each.value
}