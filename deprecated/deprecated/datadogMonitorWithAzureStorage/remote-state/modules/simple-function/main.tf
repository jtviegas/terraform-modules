resource "aws_lambda_function" "simple-function" {
  filename      = "${var.artifact}"
  function_name = "${var.name}"
  role          = "${var.role-arn}"
  handler       = "index.handler"

  runtime = "nodejs8.10"
  memory_size = 1024
  timeout = 60

}