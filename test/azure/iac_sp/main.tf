provider "azuread" {}
provider "azurerm" {
  features {}
}

# ---------- VARIABLES  -----------
variable "resource_group" { type        = string }
variable "application_registration_iac" { type        = string }
# ----------  RESOURCES  -----------
module "iac_sp" {
  source = "./modules/azure/iac_sp"
  resource_group = var.resource_group
  application_registration_iac = var.application_registration_iac
}
# ----------  OUTPUTS  -----------
output "sp_app_id" {
  value = module.iac_sp.application_iac_id
}
output "sp_pswd" {
  value = module.iac_sp.sp_iac_pswd
  sensitive = true
}