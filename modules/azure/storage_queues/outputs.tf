output "storage_account_id" {
  value = azurerm_storage_account.storage.id
}
output "storage_account_access_key" {
  value = azurerm_storage_account.storage.primary_access_key
}
output "queue_ids" {
  value = [ for q in azurerm_storage_queue.queues: q.id ]
}
