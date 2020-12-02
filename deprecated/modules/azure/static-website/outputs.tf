output "static-web-url" {
  value = data.azurerm_storage_account.main.primary_web_endpoint
}
output "static-web-host" {
  value = data.azurerm_storage_account.main.primary_web_host
}