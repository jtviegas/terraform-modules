resource "aws_s3_bucket_notification" "bucket-event-handling-notification" {
  bucket = "${var.bucket-id}"

  lambda_function {
    lambda_function_arn = "${var.function-arn}"
    events              = ["s3:ObjectCreated:Put","s3:ObjectCreated:Post"]
    filter_suffix       = "trigger"
  }
}

resource "aws_lambda_permission" "bucket-event-handling-function-permission" {
  statement_id  = "${var.notification-name}_001"
  action        = "lambda:InvokeFunction"
  function_name = "${var.function-name}"
  principal     = "s3.amazonaws.com"
  source_arn    = "${var.bucket-arn}"
}