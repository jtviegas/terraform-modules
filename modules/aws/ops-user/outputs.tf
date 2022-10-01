output "password" {
  value       = aws_iam_user_login_profile.user_profile.encrypted_password
  description = "user encrypted password"
}
output "access_key" {
  value       = aws_iam_access_key.user_access_key.secret
  description = "user access key"
  sensitive = true
}
