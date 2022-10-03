output "password" {
  value       = aws_iam_user_login_profile.user_profile.encrypted_password
  description = "user encrypted password"
}
output "access_key" {
  value       = aws_iam_access_key.user_access_key.secret
  description = "user access key"
  sensitive = true
}

output "access_key_id" {
  value       = aws_iam_access_key.user_access_key.id
  description = "user access key id"
}
