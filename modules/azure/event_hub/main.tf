terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.83.0"
    }
  }
}

data "azurerm_resource_group" "base_rg" {
  name = "${var.project}0${var.solution}0${var.env}"
}

resource "azurerm_eventhub_namespace" "event_hub_ns" {
  name                = "${var.project}0${var.solution}0${var.env}0${var.event_hub_ns_suffix}"
  resource_group_name      = data.azurerm_resource_group.base_rg.name
  location                 = data.azurerm_resource_group.base_rg.location
  sku                 = "Standard"
  capacity            = var.event_hub_ns_capacity
  auto_inflate_enabled = true
  maximum_throughput_units = var.event_hub_ns_max_throughput

  tags = {
    env = var.env
    project = var.project
    solution = var.solution
  }
}

#resource "azurerm_eventhub_namespace" "event_hub_ns_2" {
#  name                = "${var.project}0${var.solution}0${var.env}020${var.event_hub_ns_suffix}"
#  resource_group_name      = data.azurerm_resource_group.base_rg.name
#  location                 = var.event_hub_ns_2_location
#  sku                 = "Standard"
#  capacity            = var.event_hub_ns_capacity
#  auto_inflate_enabled = true
#  maximum_throughput_units = var.event_hub_ns_max_throughput

#  tags = {
#    env = var.env
#    project = var.project
#    solution = var.solution
#  }
#}

#resource "azurerm_eventhub_namespace_disaster_recovery_config" "event_hub_recovery_config" {
#  name                 = "replicate-eventhub"
#  resource_group_name  = data.azurerm_resource_group.base_rg.name
#  namespace_name       = azurerm_eventhub_namespace.event_hub_ns.name
#  partner_namespace_id = azurerm_eventhub_namespace.event_hub_ns_2.id
#}

resource "azurerm_eventhub" "event_hub" {
  name                = "${var.project}0${var.solution}0${var.env}0${var.event_hub_suffix}"
  namespace_name      = azurerm_eventhub_namespace.event_hub_ns.name
  resource_group_name = data.azurerm_resource_group.base_rg.name
  partition_count     = var.event_hub_partition_count
  message_retention   = var.event_hub_message_retention
}



#resource "azurerm_eventhub" "event_hub_2" {
#  name                = "${var.project}0${var.solution}0${var.env}020${var.event_hub_suffix}"
#  namespace_name      = azurerm_eventhub_namespace.event_hub_ns_2.name
#  resource_group_name = data.azurerm_resource_group.base_rg.name
#  partition_count     = var.event_hub_partition_count
#  message_retention   = var.event_hub_message_retention
#}

module "data_lake" {
  source = "./modules/azure/data_lake"
  project = var.project
  solution = var.solution
  env = var.env
  data_lake_store_suffix = var.data_lake_store_suffix
  data_lake_fs_name = var.data_lake_fs_name
  data_lake_paths = var.data_lake_paths
}


