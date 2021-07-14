output "password" {
  value       = aws_iam_user_login_profile.user_profile.encrypted_password
  description = "user encrypted password"
}
