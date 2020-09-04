module "entity-loader" {
  source = "../entity-loader"
  app = "${var.app}"
  environment = "${var.environment}"
  function-artifact = "${var.loader-function-artifact}"
}

module "entity-api" {
  source = "../entity-api"
  api-name = "${var.app}"
  environment = "${var.environment}"
  region = "${var.region}"
  account-id = "${var.account-id}"
  lambda-artifact = "${var.api-function-artifact}"
}

module "tables" {
    source = "../simple-tables"
    names     = var.tables
}