output "storage-account-id" {
  value = "${azurerm_storage_account.main.id}"
}
output "storage-account-access-key" {
  value = "${azurerm_storage_account.main.primary_access_key}"
}
output "storage-container-id" {
  value = "${azurerm_storage_container.main.id}"
}