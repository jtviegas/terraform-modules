
output "arns" {
  value       = values(aws_dynamodb_table.simple-tables)[*].arn
  description = "the tables arn"
}

output "ids" {
  value       = values(aws_dynamodb_table.simple-tables)[*].id
  description = "the tables id"
}


