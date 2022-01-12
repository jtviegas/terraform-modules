terraform {
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
variable "location" {
  type        = string
  default     = "West Europe"
}
variable "geo" {
  type        = string
  default     = "weu"
}
variable "env" { type        = string }
variable "resource_group" { type        = string }
variable "configuration_store_account" { type        = string }
variable "tfstate_storage_container" { type        = string }
# ----------  RESOURCES  -----------
resource "azurerm_resource_group" "base_rg" {
  name     = var.resource_group
  location = var.location
}

# ARM_ACCESS_KEY
resource "azurerm_storage_account" "config" {
  name                     = var.configuration_store_account
  resource_group_name      = azurerm_resource_group.base_rg.name
  location                 = azurerm_resource_group.base_rg.location
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

resource "azurerm_storage_container" "tfstate" {
  name                  = var.tfstate_storage_container
  storage_account_name  = azurerm_storage_account.config.name
}

# ----------  OUTPUTS  -----------

output "resource_group_id" {
  value = azurerm_resource_group.base_rg.id
}
output "resource_group_name" {
  value = azurerm_resource_group.base_rg.name
}
output "storage_account_id" {
  value = azurerm_storage_account.config.id
}
output "storage_account_name" {
  value = azurerm_storage_account.config.name
}
output "storage_account_access_key" {
  value = azurerm_storage_account.config.primary_access_key
  sensitive = true
}
output "storage_container_id" {
  value = azurerm_storage_container.tfstate.id
}
output "storage_container_name" {
  value = azurerm_storage_container.tfstate.name
}