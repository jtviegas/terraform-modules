output "admin_pswd" {
  value       = aws_iam_user_login_profile.admin.encrypted_password
  description = "admin encrypted password"
}
