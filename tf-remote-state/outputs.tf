
output "s3-bucket-terraform-state_arn" {
  value       = aws_s3_bucket.terraform-state.arn
  description = "the bucket arn"
}

output "s3-bucket-terraform-state_id" {
  value       = aws_s3_bucket.terraform-state.id
  description = "the bucket id"
}

output "dyndb-table-terraform-state_arn" {
  value       = aws_dynamodb_table.terraform-state-lock.arn
  description = "the table arn"
}

output "dyndb-table-terraform-state_id" {
  value       = aws_dynamodb_table.terraform-state-lock.id
  description = "the table id"
}

