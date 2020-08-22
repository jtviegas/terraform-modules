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

module "static-website" {
  source = "../../modules/azure/static-website"
  app = "${var.app}"
  env = "${var.env}"
  resource-group-name = "${azurerm_resource_group.main.name}"
  resource-group-region = "${azurerm_resource_group.main.location}"
}

output "static-web-url" {
  value = module.static-website.static-web-url
}
output "static-web-host" {
  value = module.static-website.static-web-host
}
