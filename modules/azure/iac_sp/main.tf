terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "=2.13.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.90.0"
    }
  }
}

# ---------- VARIABLES  -----------
variable "resource_group" { type        = string }
variable "application_registration_iac" { type = string }

# ----------  RESOURCES  -----------
data "azurerm_client_config" "current" {}
data "azurerm_resource_group" "current" { name = var.resource_group }
data "azurerm_subscription" "current" {}

## -------  service principals
data "azuread_service_principal" "sp_eventhubs" {
  display_name = "Microsoft.EventHubs"
}
resource "azuread_application" "app_registration_iac" {
  display_name = var.application_registration_iac
}
resource "azuread_service_principal" "iac" {
  application_id               = azuread_application.app_registration_iac.application_id
  app_role_assignment_required = false
  alternative_names             = ["sp_iac"]
}
resource "azuread_service_principal_password" "iac" {
  service_principal_id = azuread_service_principal.iac.object_id
}
## -------  service principal roles
resource "azurerm_role_assignment" "iac_group_role_owner" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Owner"
  principal_id       = azuread_service_principal.iac.id
}
resource "azurerm_role_assignment" "sp_iac_role_contributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id       = azuread_service_principal.iac.id
}
resource "azurerm_role_assignment" "iac_group_role_appconfig_data_owner" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "App Configuration Data Owner"
  principal_id       = azuread_service_principal.iac.id
}
resource "azurerm_role_assignment" "iac_group_role_keyvault_admin" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Key Vault Administrator"
  principal_id       = azuread_service_principal.iac.id
}
resource "azurerm_role_assignment" "iac_group_role_keyvault_secrets_officer" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id       = azuread_service_principal.iac.id
}
resource "azurerm_role_assignment" "iac_group_role_user_access_admin" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "User Access Administrator"
  principal_id       = azuread_service_principal.iac.id
}

# ----------  OUTPUTS  -----------
output "application_iac_id" { value = azuread_application.app_registration_iac.application_id }
output "sp_iac_pswd" {
  value = azuread_service_principal_password.iac.value
  sensitive = true
}
output "sp_eventhubs_object_id" {
  value = data.azuread_service_principal.sp_eventhubs.object_id
  sensitive = true
}
