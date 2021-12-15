terraform {
  backend "azurerm" {
    resource_group_name  = "rg0eng0tfmod0team0dev"
    storage_account_name = "st0base0dev0weu0001"
    container_name       = "stc0tfstate0001"
    key                  = "api0reader0sp"
  }
}

provider "azurerm" {
  features {}
}

variable "businessunit" {
  type        = string
}
variable "solution" {
  type        = string
}
variable "client" {
  type        = string
}
variable "env" {
  type        = string
}
variable "name" {
  type        = string
}
variable "instance" {
  type        = string
}

module "api_reader_sp" {
  source = "./modules/azure/api_reader_sp"
  businessunit = var.businessunit
  solution = var.solution
  client = var.client
  env = var.env
  name = var.name
  instance = var.instance
}

output "sp_object_id" {
  value = module.api_reader_sp.object_id
}

output "sp_pswd" {
  value = module.api_reader_sp.pswd
}

