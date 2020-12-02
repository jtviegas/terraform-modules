output "arn" {
  value       = aws_s3_bucket.simple-bucket.arn
  description = "the bucket arn"
}

output "id" {
  value       = aws_s3_bucket.simple-bucket.id
  description = "the bucket id"
}
