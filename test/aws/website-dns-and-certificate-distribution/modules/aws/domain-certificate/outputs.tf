output "id" {
  value       = aws_acm_certificate.domain_certificate.id
  description = "the id of the certificate"
}
output "arn" {
  value       = aws_acm_certificate.domain_certificate.arn
  description = "the certificate arn"
}
output "domain_name" {
  value       = aws_acm_certificate.domain_certificate.domain_name
  description = "the certificate domain name"
}


