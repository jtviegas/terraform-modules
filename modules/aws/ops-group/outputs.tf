output "group_id" {
  value       = aws_iam_group.admin.id
  description = "The group's ID"
}

output "group_arn" {
  value       = aws_iam_group.admin.arn
  description = "The ARN assigned by AWS for this group"
}

output "group_unique_id" {
  value       = aws_iam_group.admin.unique_id
  description = "The unique ID assigned by AWS"
}

