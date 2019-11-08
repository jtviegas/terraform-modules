
output "bucket-arn" {
  value       = aws_s3_bucket.terraform-state.arn
  description = "the bucket arn"
}

output "bucket-id" {
  value       = aws_s3_bucket.terraform-state.id
  description = "the bucket id"
}

output "table-arn" {
  value       = aws_dynamodb_table.terraform-state-lock.arn
  description = "the table arn"
}

output "table-id" {
  value       = aws_dynamodb_table.terraform-state-lock.id
  description = "the table id"
}

