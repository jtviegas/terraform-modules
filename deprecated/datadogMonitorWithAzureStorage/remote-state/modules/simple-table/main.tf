resource "aws_dynamodb_table" "simple-table" {
  name           = "${var.name}"
  billing_mode = "PAY_PER_REQUEST"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "id"
  attribute {
    name = "id"
    type = "N"
  }
}