
output "arn" {
  value       = aws_dynamodb_table.simple-table.arn
  description = "the table arn"
}
output "id" {
  value       = aws_dynamodb_table.simple-table.id
  description = "the table id"
}


