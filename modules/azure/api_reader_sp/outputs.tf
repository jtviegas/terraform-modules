output "object_id" {
  value = azuread_service_principal.app_sp.object_id
}

output "pswd" {
  value = azuread_service_principal_password.app_sp_pswd.value
}

