
resource "azurerm_storage_account" "main" {
  name                     = "${var.app}0${var.env}"
  resource_group_name      = "${var.resource-group-name}"
  location                 = "${var.resource-group-region}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  tags = {
    environment = "${var.env}"
    app = "${var.app}"
  }
}

module "staticweb" {
  source               = "StefanSchoof/static-website/azurerm"
  storage_account_name = azurerm_storage_account.main.name
}

data "azurerm_storage_account" "main" {
  name                = azurerm_storage_account.main.name
  resource_group_name = "${var.resource-group-name}"
  depends_on = ["module.staticweb"]
}



