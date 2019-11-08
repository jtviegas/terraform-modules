module "bucket" {
  source = "../simple-bucket"
  name = "${var.bucket-name}"
}

module "function-role" {
  source = "../bucket-event-handling-role"
  name = "${var.function-role-name}"
  bucket-id = module.bucket.id
}

module "function" {
  source = "../simple-function"
  artifact = "${var.function-artifact}"
  name = "${var.function-name}"
  role-arn = "${module.function-role.arn}"
}

module "notification" {
  source = "../bucket-event-handling-notification"
  notification-name = "${var.notification-name}"
  function-name = "${var.function-name}"
  function-arn = "${module.function.arn}"
  bucket-arn = "${module.bucket.arn}"
  bucket-id = "${module.bucket.id}"
  
}
