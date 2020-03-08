
resource "azurerm_storage_account" "main" {
  name                     = "${var.storage-account-name}"
  resource_group_name      = "${var.resource-group-name}"
  location                 = "${var.resource-group-region}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    env = "${var.env}"
    team = "${var.team}"
    project = "${var.project}"
    app = "${var.app}"
  }
}

resource "azurerm_storage_container" "main" {
  name                  = "${var.storage-container-name}"
  storage_account_name  = "${azurerm_storage_account.main.name}"
}

