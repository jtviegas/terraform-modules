terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.39.1"
    }
  }
}

variable "resource_group" { type = string }
variable "data_lake_storage_account" { type = string }
variable "solution" { type = string }
variable "env" { type = string }
variable "data_lake_fs_name" { type = string }
variable "data_lake_path" { type    = string }
variable "data_lake_privpath" { type    = string }
variable "owner_id" { type    = string }
variable "guest_id" { type    = string }
variable "owner_group_id" { type    = string }
variable "guest_group_id" { type    = string }

data "azurerm_resource_group" "base_rg" {
  name = var.resource_group
}

resource "azurerm_storage_account" "data_lake" {
  name                     = var.data_lake_storage_account
  resource_group_name      = data.azurerm_resource_group.base_rg.name
  location                 = data.azurerm_resource_group.base_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = true

  tags = {
    solution = var.solution
    env = var.env
  }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "data_lake_fs" {
  name               = var.data_lake_fs_name
  storage_account_id = azurerm_storage_account.data_lake.id

  ace {
    scope = "default"
    type = "other"
    permissions = "r-x"
  }
  ace {
    scope = "default"
    type = "user"
    id = var.owner_id
    permissions = "rwx"
  }
  ace {
    scope = "access"
    type = "other"
    permissions = "r-x"
  }
  ace {
    scope = "access"
    type = "user"
    id = var.owner_id
    permissions = "rwx"
  }
}

resource "azurerm_storage_data_lake_gen2_path" "data_lake_path" {
  path               = var.data_lake_path
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.data_lake_fs.name
  storage_account_id = azurerm_storage_account.data_lake.id
  resource           = "directory"

  ace {
    scope = "access"
    type = "user"
    id = var.guest_id
    permissions = "r-x"
  }
  ace {
    scope = "access"
    type = "user"
    id = var.owner_id
    permissions = "rwx"
  }

  ace {
    scope = "default"
    type = "user"
    id = var.guest_id
    permissions = "r-x"
  }

  ace {
    scope = "default"
    type = "user"
    id = var.owner_id
    permissions = "rwx"
  }

}

resource "azurerm_storage_data_lake_gen2_path" "data_lake_privpath" {
  path               = var.data_lake_privpath
  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.data_lake_fs.name
  storage_account_id = azurerm_storage_account.data_lake.id
  resource           = "directory"

  ace {
    scope = "default"
    type = "other"
    permissions = "---"
  }

  ace {
    scope = "default"
    type = "user"
    id = var.owner_id
    permissions = "rwx"
  }

  ace {
    scope = "access"
    type = "other"
    permissions = "---"
  }

  ace {
    scope = "access"
    type = "user"
    id = var.owner_id
    permissions = "rwx"
  }

}


