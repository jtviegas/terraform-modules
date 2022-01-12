terraform {
  backend "azurerm" { key = "solution_scaffolding" }
}

provider "azurerm" {
  features {}
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
variable "resource_group" { type        = string }
variable "log_analytics_ws" { type        = string }
variable "application_insights" { type        = string }
variable "application_configuration" { type        = string }
variable "key_vault" { type        = string }
# ----------  RESOURCES  -----------
module "solution_scaffolding" {
  source = "./modules/azure/solution_scaffolding"
  businessunit = var.businessunit
  solution = var.solution
  solution_short = var.solution_short
  component = var.component
  client = var.client
  location = var.location
  geo = var.geo
  env = var.env
  resource_group = var.resource_group
  log_analytics_ws = var.log_analytics_ws
  application_insights = var.application_insights
  application_configuration = var.application_configuration
  key_vault = var.key_vault
}
# ----------  OUTPUTS  -----------
