# don't forget => export ARM_ACCESS_KEY=........
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

data "azurerm_resource_group" "main" {
  name = "${var.app}0${var.env}"
}

terraform {
  backend "azurerm" {
    storage_account_name  = "app0dev0tfstate"
    container_name        = "app0dev0tfstate"
    key                   = "terraform.tfstate"
  }
}

module "static-website" {
  source = "../../../../modules/azure/static-website"
  app = "${var.app}"
  env = "${var.env}"
  resource-group-name = "${data.azurerm_resource_group.main.name}"
  resource-group-region = "${data.azurerm_resource_group.main.location}"
}

output "static-web-url" {
  value = module.static-website.static-web-url
}
output "static-web-host" {
  value = module.static-website.static-web-host
}
