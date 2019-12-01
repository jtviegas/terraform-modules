
resource "azurerm_storage_account" "main" {
  name                     = "${var.app}0${var.env}0tfstate"
  resource_group_name      = "${var.resource-group-name}"
  location                 = "${var.resource-group-region}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "${var.env}"
    app = "${var.app}"
  }
}

resource "azurerm_storage_container" "main" {
  name                  = "${var.app}0${var.env}0tfstate"
  storage_account_name  = "${azurerm_storage_account.main.name}"
}

