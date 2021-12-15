output "storage_account_id" {
  value = azurerm_storage_account.storageaccount_for_table.id
}
output "storage_account_access_key" {
  value = azurerm_storage_account.storageaccount_for_table.primary_access_key
}
output "storage_table_id" {
  value = azurerm_storage_table.storage_table.id
}


