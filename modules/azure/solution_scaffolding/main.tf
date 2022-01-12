terraform {
#  backend "azurerm" { key = "solution_scaffolding" }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.90.0"
    }
  }
}

# ---------- VARIABLES  -----------
variable "businessunit" { type        = string }
variable "solution" { type        = string }
variable "solution_short" { type        = string }
variable "component" { type        = string }
variable "client" { type        = string }
variable "location" { type        = string }
variable "geo" { type        = string }
variable "env" { type        = string }
variable "resource_group" { type = string }
variable "log_analytics_ws" { type        = string }
variable "application_insights" { type        = string }
variable "application_configuration" { type        = string }
variable "key_vault" { type        = string }


# ----------  RESOURCES  -----------
data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}
data "azurerm_resource_group" "current" { name = var.resource_group }
## -------  log analytics workspace
resource "azurerm_log_analytics_workspace" "log_analytics_ws" {
  name                = var.log_analytics_ws
  resource_group_name = data.azurerm_resource_group.current.name
  location            = data.azurerm_resource_group.current.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags = {
    businessunit = var.businessunit
    solution = var.solution
    client = var.client
    environment = var.env
    geography = var.geo
  }
}
## -------  application insights
resource "azurerm_application_insights" "app_insights" {
  name                = var.application_insights
  resource_group_name = data.azurerm_resource_group.current.name
  location            = data.azurerm_resource_group.current.location
  workspace_id        = azurerm_log_analytics_workspace.log_analytics_ws.id
  application_type    = "other"
}
## -------  app configuration
resource "azurerm_app_configuration" "app" {
  name                     = var.application_configuration
  resource_group_name      = data.azurerm_resource_group.current.name
  location                 = data.azurerm_resource_group.current.location
  sku                      = "standard"
}
## -------  key vault
resource "azurerm_key_vault" "app" {
  name                     = var.key_vault
  resource_group_name      = data.azurerm_resource_group.current.name
  location                 = data.azurerm_resource_group.current.location
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name = "standard"
}
resource "azurerm_key_vault_access_policy" "iac" {
  key_vault_id = azurerm_key_vault.app.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id
  secret_permissions = ["Get", "Delete", "Set", "List", "Purge", "Set", "Recover", "Restore"]
}


# ----------  OUTPUTS  -----------

