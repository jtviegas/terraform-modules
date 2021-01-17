provider "datadog" {
  api_key = "${var.datadog_api_key}"
  app_key = "${var.datadog_app_key}"
  api_url = "${var.datadog_url}"
}

terraform {
  backend "azurerm" {
    storage_account_name  = "devpennyremotestates"
    container_name        = "knapsack"
    key                   = "api-monitoring"
  }
}

module "monitor-api-uptime" {
  source = "./modules/datadog/monitor-uptime"
  service-name = "${var.service-name}"
  team = "${var.team}"
  project = "${var.project}"
  notification-list = "${var.notification-list}"
}

module "slo-api-uptime" {
  source = "./modules/datadog/slo-uptime"
  service-name = "${var.service-name}"
  team = "${var.team}"
  project = "${var.project}"
  monitor-id = module.monitor-api-uptime.id
}

module "monitor-api-successrate" {
  source = "./modules/datadog/monitor-sucessrate"
  service-name = "${var.service-name}"
  team = "${var.team}"
  project = "${var.project}"
  notification-list = "${var.notification-list}"
}

module "slo-api-successrate" {
  source = "./modules/datadog/slo-successrate"
  service-name = "${var.service-name}"
  team = "${var.team}"
  project = "${var.project}"
}
