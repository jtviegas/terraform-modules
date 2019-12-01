provider "azurerm" {
  version = "=1.36.0"
}

variable "app" {
  type        = string
  default     = "app"
}

variable "env" {
  type        = string
  default     = "dev"
}

variable "region" {
  type        = string
  default     = "West Europe"
}

resource "azurerm_resource_group" "main" {
  name     = "${var.app}0${var.env}"
  location = "${var.region}"
}

module "tf-remote-state" {
  source = "../../../../modules/azure/tf-remote-state"
  app = "${var.app}"
  env = "${var.env}"
  resource-group-name = "${azurerm_resource_group.main.name}"
  resource-group-region = "${azurerm_resource_group.main.location}"
}

output "storage-account-id" {
  value = module.tf-remote-state.storage-account-id
}
output "storage-account-access-key" {
  value = module.tf-remote-state.storage-account-access-key
}
output "storage-container-id" {
  value = module.tf-remote-state.storage-container-id
}
