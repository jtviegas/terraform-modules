output "name" {
  value       = aws_s3_bucket.website-bucket.id
  description = "the bucket name"
}
output "arn" {
  value       = aws_s3_bucket.website-bucket.arn
  description = "the bucket arn"
}
output "endpoint" {
  value       = aws_s3_bucket.website-bucket.website_endpoint
  description = "the website endpoint"
}

output "domain" {
  value       = aws_s3_bucket.website-bucket.website_domain
  description = "the website domain"
}

output "hosted_zone_id" {
  value       = aws_s3_bucket.website-bucket.hosted_zone_id
  description = "the website route 53 hosted zone id"
}

output "distribution_domain_name" {
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
  description = "the domain name of the distribution"
}

