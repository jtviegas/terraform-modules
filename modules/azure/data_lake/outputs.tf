output "data_lake_store_id" {
  value = azurerm_storage_account.data_lake.id
}

output "data_lake_store_primary_location" {
  value = azurerm_storage_account.data_lake.primary_location
}

output "data_lake_store_secondary_location" {
  value = azurerm_storage_account.data_lake.secondary_location
}

output "data_lake_store_primary_access_key" {
  value = azurerm_storage_account.data_lake.primary_access_key
}

output "data_lake_store_secondary_access_key" {
  value = azurerm_storage_account.data_lake.secondary_access_key
}

output "data_lake_store_primary_connection_string" {
  value = azurerm_storage_account.data_lake.primary_connection_string
}

output "data_lake_store_secondary_connection_string" {
  value = azurerm_storage_account.data_lake.secondary_connection_string
}

output "data_lake_store_primary_blob_connection_string" {
  value = azurerm_storage_account.data_lake.primary_blob_connection_string
}

output "data_lake_store_secondary_blob_connection_string" {
  value = azurerm_storage_account.data_lake.secondary_blob_connection_string
}
