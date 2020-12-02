module "bucket-event-handling" {
  source = "../bucket-event-handling"
  bucket-name = "${var.app}-${var.environment}-entities"
  function-name = "${var.app}-${var.environment}-entity-loader"
  function-artifact = "${var.function-artifact}"
  function-role-name = "${var.app}-${var.environment}-entity-loader-role"
  notification-name = "${var.app}-${var.environment}-entity-loader-notification"
}

