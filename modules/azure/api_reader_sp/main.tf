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

resource "azuread_application" "app" {
  display_name = "app0${var.businessunit}0${var.solution}0${var.client}0${var.env}0${var.name}"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "app_sp" {
  application_id               = azuread_application.app.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_password" "app_sp_pswd" {
  service_principal_id = azuread_service_principal.app_sp.object_id
}