
output "bucket_arn" {
  value       = aws_s3_bucket.terraform_state.arn
  description = "the bucket arn"
}

output "bucket_id" {
  value       = aws_s3_bucket.terraform_state.id
  description = "the bucket id"
}

output "table_arn" {
  value       = aws_dynamodb_table.terraform_state_lock.arn
  description = "the table arn"
}

output "table_id" {
  value       = aws_dynamodb_table.terraform_state_lock.id
  description = "the table id"
}

