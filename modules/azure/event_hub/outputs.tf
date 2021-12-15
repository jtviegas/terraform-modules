output "event_hub_ns_id" {
  value = azurerm_eventhub_namespace.event_hub_ns.id
}

output "event_hub_ns_identity" {
  value = azurerm_eventhub_namespace.event_hub_ns.identity
}

output "event_hub_ns_default_primary_connection_string" {
  value = azurerm_eventhub_namespace.event_hub_ns.default_primary_connection_string
}

output "event_hub_ns_default_primary_connection_string_alias" {
  value = azurerm_eventhub_namespace.event_hub_ns.default_primary_connection_string_alias
}

output "event_hub_ns_default_primary_key" {
  value = azurerm_eventhub_namespace.event_hub_ns.default_primary_key
}

output "event_hub_ns_default_secondary_connection_string" {
  value = azurerm_eventhub_namespace.event_hub_ns.default_secondary_connection_string
}

output "event_hub_ns_default_secondary_connection_string_alias" {
  value = azurerm_eventhub_namespace.event_hub_ns.default_secondary_connection_string_alias
}

output "event_hub_ns_default_secondary_key" {
  value = azurerm_eventhub_namespace.event_hub_ns.default_secondary_key
}