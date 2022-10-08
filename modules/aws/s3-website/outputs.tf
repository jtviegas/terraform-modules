output "name" {
  value       = aws_s3_bucket.website_bucket.id
  description = "the bucket name"
}
output "arn" {
  value       = aws_s3_bucket.website_bucket.arn
  description = "the bucket arn"
}
output "endpoint" {
  value       = aws_s3_bucket_website_configuration.website_bucket.website_endpoint
  description = "the website endpoint"
}

output "domain" {
  value       = aws_s3_bucket_website_configuration.website_bucket.website_domain
  description = "the website domain"
}

output "hosted_zone_id" {
  value       = aws_s3_bucket.website_bucket.hosted_zone_id
  description = "the website route 53 hosted zone id"
}


