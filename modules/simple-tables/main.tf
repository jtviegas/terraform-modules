resource "aws_dynamodb_table" "simple-tables" {
  for_each = toset(var.names)
  name     = each.value
  billing_mode = "PAY_PER_REQUEST"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "id"
  attribute {
    name = "id"
    type = "N"
  }
}