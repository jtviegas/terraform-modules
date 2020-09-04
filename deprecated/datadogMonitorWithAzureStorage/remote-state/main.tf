provider "azurerm" {
  version = "=2.0.0"
  features {}
}


module "tf-remote-state" {
  source = "./modules/azure/tf-remote-state"
  app = "${var.app}"
  env = "${var.env}"
  resource-group-name = "${var.resource-group}"
  resource-group-region = "${var.region}"
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
