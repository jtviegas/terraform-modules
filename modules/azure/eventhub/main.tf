terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.90.0"
    }
  }
}

# ---------- VARIABLES  -----------
variable "businessunit" { type        = string }
variable "solution" { type        = string }
variable "solution_short" { type        = string }
variable "component" { type        = string }
variable "client" { type        = string }
variable "location" { type        = string }
variable "geo" { type        = string }
variable "env" { type        = string }
variable "resource_group" { type = string }

variable "eventhub" { type = string }
variable "eventhub_ns" { type = string }
variable "eventhub_ns_capacity" {
  type        = number
  default     = 1
  description = "Specifies the Capacity / Throughput Units for a Standard SKU namespace. 1 throughput unit per day is equivalent to 1 MB per second. Default capacity has a maximum of 20, but can be increased in blocks of 20 on a committed purchase basis."
}
variable "eventhub_ns_max_throughput" {
  type        = number
  default     = 3
  description = "Specifies the maximum number of throughput units when Auto Inflate is Enabled. Valid values range from 1 - 20"
}
variable "eventhub_partition_count" {
  type        = number
  default     = 2
  description = "Each partition can only utilize a single throughput unit, partition count controls the maximum parallel consumers that can process messages simultaneously. The minimum is two, which allows for redundancy in the system. "
}

variable "eventhub_message_retention" {
  type        = number
  default     = 1
  description = "message retention in days, between 1 and 7"
}
#variable "eventhub_2" { type = string }
#variable "eventhub_ns_2" { type = string }
#variable "location_2" { type = string }
#variable "geo_2" { type = string }
#variable "eventhub_namespace_disaster_recovery_config" { type = string }

variable "eventhub_data_capture_storage_account" { type = string }
variable "eventhub_data_capture_storage_container" { type = string }

variable "sp_eventhubs_object_id" { type = string }

# ----------  RESOURCES  -----------
data "azurerm_resource_group" "current" { name = var.resource_group }
resource "azurerm_storage_account" "data_capture_storage_account" {
  name                     = var.eventhub_data_capture_storage_account
  resource_group_name      = data.azurerm_resource_group.current.name
  location                 = data.azurerm_resource_group.current.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "BlobStorage"
#  is_hns_enabled           = true

  tags = {
    businessunit = var.businessunit
    solution = var.solution
    client = var.client
    environment = var.env
    geography = var.geo
  }
}
resource "azurerm_storage_container" "data_capture_storage_container" {
  name                  = var.eventhub_data_capture_storage_container
  storage_account_name  = azurerm_storage_account.data_capture_storage_account.name
}

#resource "azurerm_storage_data_lake_gen2_filesystem" "data_capture_data_lake_fs" {
#  name               = var.datalake_eventhub_data_capture_fs
#  storage_account_id = azurerm_storage_account.data_capture_data_lake.id
#}
#resource "azurerm_storage_data_lake_gen2_path" "data_capture_data_lake_paths" {
#  path               = var.datalake_eventhub_data_capture_path
#  filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.data_capture_data_lake_fs.name
#  storage_account_id = azurerm_storage_account.data_capture_data_lake.id
#  resource           = "directory"
#  ace {
#    type = "user"
#    id = var.sp_eventhubs_object_id
#    permissions = "rwx"
#  }
#}

resource "azurerm_eventhub_namespace" "eventhub_ns" {
  name                = var.eventhub_ns
  resource_group_name      = data.azurerm_resource_group.current.name
  location                 = data.azurerm_resource_group.current.location
  sku                 = "Standard"
  capacity            = var.eventhub_ns_capacity
  auto_inflate_enabled = true
  maximum_throughput_units = var.eventhub_ns_max_throughput
  identity {
    type = "SystemAssigned"
  }

  tags = {
    businessunit = var.businessunit
    solution = var.solution
    client = var.client
    environment = var.env
    geography = var.geo
  }
}
resource "azurerm_eventhub" "eventhub" {
  name                = var.eventhub
  namespace_name      = azurerm_eventhub_namespace.eventhub_ns.name
  resource_group_name = data.azurerm_resource_group.current.name
  partition_count     = var.eventhub_partition_count
  message_retention   = var.eventhub_message_retention
  capture_description {
    enabled  = true
    encoding = "Avro"
    size_limit_in_bytes = 10485760
    destination {
      archive_name_format = "{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}"
      blob_container_name = azurerm_storage_container.data_capture_storage_container.name
      name                = "EventHubArchive.AzureBlockBlob"
      storage_account_id  = azurerm_storage_account.data_capture_storage_account.id
    }
  }
}
#resource "azurerm_eventhub_namespace" "eventhub_ns_2" {
#  name                = var.eventhub_ns_2
#  resource_group_name      = data.azurerm_resource_group.current.name
#  location                 = var.location_2
#  sku                 = "Standard"
#  capacity            = var.eventhub_ns_capacity
#  auto_inflate_enabled = true
#  maximum_throughput_units = var.eventhub_ns_max_throughput
#  identity {
#      type = "SystemAssigned"
#    }
#  tags = {
#    businessunit = var.businessunit
#    solution = var.solution
#    client = var.client
#    environment = var.env
#    geography = var.geo_2
#  }
#}
#resource "azurerm_eventhub" "eventhub_2" {
#  name                = var.eventhub_2
#  namespace_name      = azurerm_eventhub_namespace.eventhub_ns_2.name
#  resource_group_name = data.azurerm_resource_group.current.name
#  partition_count     = var.eventhub_partition_count
#  message_retention   = var.eventhub_message_retention
#}
#resource "azurerm_eventhub_namespace_disaster_recovery_config" "eventhub_recovery_config" {
#  name                 = var.eventhub_namespace_disaster_recovery_config
#  resource_group_name  = data.azurerm_resource_group.current.name
#  namespace_name       = azurerm_eventhub_namespace.eventhub_ns.name
#  partner_namespace_id = azurerm_eventhub_namespace.eventhub_ns_2.id
#}




# ----------  OUTPUTS  -----------

output "id" {
  value = azurerm_eventhub_namespace.eventhub_ns.id
}

output "sp_id" {
  value = azurerm_eventhub_namespace.eventhub_ns.identity.0.principal_id
}

output "primary_connection_string" {
  value = azurerm_eventhub_namespace.eventhub_ns.default_primary_connection_string
  sensitive = true
}

#output "primary_connection_string_alias" {
#  value = azurerm_eventhub_namespace.eventhub_ns.default_primary_connection_string_alias
#}

output "primary_key" {
  value = azurerm_eventhub_namespace.eventhub_ns.default_primary_key
  sensitive = true
}



