#provider "datadog" {
#  api_key = "${var.datadog_api_key}"
#  app_key = "${var.datadog_app_key}"
#  api_url = "${var.datadog_url}"
#}

#terraform {
#  backend "azurerm" {
#    storage_account_name  = "knapsack0dev0tfstate"
#    container_name        = "knapsack0dev0tfstate"
#    key                   = "knapsack0dev"
#  }
#}
resource "datadog_service_level_objective" "service-uptime" {
  name               = "${var.team} ${var.project} ${var.service-name} => uptime"
  type               = "monitor"
  description        = "uptime SLO for ${var.team} ${var.project} ${var.service-name}"
  monitor_ids = [ var.monitor-id ]

  thresholds {
    timeframe = "7d"
    target = var.target-threshold
    warning = var.warning-threshold
  }

  thresholds {
    timeframe = "30d"
    target = var.target-threshold
    warning = var.warning-threshold
  }

  thresholds {
    timeframe = "90d"
    target = var.target-threshold
    warning = var.warning-threshold
  }

  tags = ["team:${var.team}", "project:${var.project}", "service:${var.service-name}", "uptime", "slo"]
}

