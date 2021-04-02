output "group_id" {
  value       = aws_iam_group.admin.id
  description = "The group ID"
}

output "group_arn" {
  value       = aws_iam_group.admin.arn
  description = "The ARN assigned by AWS for this group"
}

output "group_unique_id" {
  value       = aws_iam_group.admin.unique_id
  description = "The unique ID assigned by AWS"
}

output "role_id" {
  value       = aws_iam_role.admin_role.id
  description = "The role ID"
}

output "role_arn" {
  value       = aws_iam_role.admin_role.arn
  description = "The role arn"
}