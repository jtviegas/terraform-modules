output "storage_account_id" {
  value = azurerm_storage_account.storage.id
}
output "storage_account_access_key" {
  value = azurerm_storage_account.storage.primary_access_key
}
output "storage_container_id" {
  value = azurerm_storage_container.container.id
}