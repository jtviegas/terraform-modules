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

resource "datadog_monitor" "service-uptime" {
  name               = "${var.service-name} => uptime"
  type               = "query alert"
  query = "avg(last_1m):min:kubernetes.pods.running{kube_service:${var.service-name}}.fill(zero, 60) < 0.99"
  message            = "{{#is_alert}}\nplease check ${var.service-name} instance count !\n{{/is_alert}}\n{{#is_recovery}}\n${var.service-name} instance count has recovered !\n{{/is_recovery}}\n\nNotify: ${var.notification-list}"
  include_tags = true
  tags = ["team:${var.team}", "project:${var.project}", "service:${var.service-name}", "uptime"]
  notify_audit = true
  locked = true
  timeout_h = 0
  silenced = {}
  no_data_timeframe = 5
  require_full_window = true
  new_host_delay = 300
  notify_no_data = true
  renotify_interval = 10
  escalation_message = "Attention: ${var.service-name} instance count has not yet recovered !!!\nplease do check !!!\n\nNotify: ${var.notification-list}"
  thresholds = {
    warning           = 1.99
    warning_recovery  = 2
    critical          = 0.99
    critical_recovery = 1
  }
}
