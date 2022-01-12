terraform {
  backend "azurerm" { key = "eventhub" }
}

provider "azurerm" {
  features {}
}

#data "azuread_service_principal" "sp_eventhubs" {
#  display_name = "Microsoft.EventHubs"
#}

# ---------- VARIABLES  -----------
variable "businessunit" { type        = string }
variable "solution" { type        = string }
variable "solution_short" { type        = string }
variable "component" { type        = string }
variable "client" { type        = string }
variable "location" { type        = string }
variable "geo" { type        = string }
variable "env" { type        = string }
variable "resource_group" { type        = string }

variable "application_configuration" { type        = string }
variable "key_vault" { type        = string }

variable "eventhub" { type        = string }
variable "eventhub_ns" { type        = string }

#variable "location_2" { type        = string }
#variable "geo_2" { type        = string }

variable "eventhub_data_capture_storage_account" { type        = string }
variable "eventhub_data_capture_storage_container" { type        = string }

variable "sp_eventhubs_object_id" { type = string }

# ----------  RESOURCES  -----------
data "azurerm_resource_group" "current" { name = var.resource_group }

module "eventhub" {
  source = "./modules/azure/eventhub"
  businessunit = var.businessunit
  solution = var.solution
  solution_short = var.solution_short
  component = var.component
  client = var.client
  location = data.azurerm_resource_group.current.location
  geo = var.geo
  env = var.env
  resource_group = data.azurerm_resource_group.current.name
  eventhub = var.eventhub
  eventhub_ns = var.eventhub_ns
  eventhub_data_capture_storage_account = var.eventhub_data_capture_storage_account
  eventhub_data_capture_storage_container = var.eventhub_data_capture_storage_container
  sp_eventhubs_object_id = var.sp_eventhubs_object_id
}
data "azurerm_app_configuration" "app" {
  name                = var.application_configuration
  resource_group_name = data.azurerm_resource_group.current.name
}
resource "azurerm_app_configuration_key" "eventhub_id" {
  configuration_store_id = data.azurerm_app_configuration.app.id
  key                    = "eventhub-id"
  value                  = module.eventhub.id
  label                  = "${var.businessunit}0${var.solution}0${var.client}0${var.env}0${var.geo}"
}
resource "azurerm_app_configuration_key" "eventhub_sp_id" {
  configuration_store_id = data.azurerm_app_configuration.app.id
  key                    = "eventhub-sp-id"
  value                  = module.eventhub.sp_id
  label                  = "${var.businessunit}0${var.solution}0${var.client}0${var.env}0${var.geo}"
}
data "azurerm_key_vault" "app" {
  name                     = var.key_vault
  resource_group_name      = data.azurerm_resource_group.current.name
}
resource "azurerm_key_vault_secret" "eventhub_key" {
  name         = "eventhub-key"
  value        = module.eventhub.primary_key
  key_vault_id = data.azurerm_key_vault.app.id
}
resource "azurerm_key_vault_secret" "eventhub_connection_string" {
  name         = "eventhub-connection-string"
  value        = module.eventhub.primary_connection_string
  key_vault_id = data.azurerm_key_vault.app.id
}
# ----------  OUTPUTS  -----------

output "id" {
  value = module.eventhub.id
}
output "sp_id" {
  value = module.eventhub.sp_id
}
output "primary_connection_string" {
  value = module.eventhub.primary_connection_string
  sensitive = true
}
output "primary_key" {
  value = module.eventhub.primary_key
  sensitive = true
}

