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

resource "datadog_monitor" "service-sucessrate" {
  name               = "${var.team} ${var.project} ${var.service-name} => sucess rate"
  type               = "query alert"
  query = "avg(last_5m):sum:trace.servlet.request.hits.by_http_status{http.status_class:2xx,project:${var.project},service:${var.service-name}}.as_count() / sum:trace.servlet.request.hits.by_http_status{service:${var.service-name},project:${var.project}}.as_count() < ${var.critical-threshold}"
  message            = "{{#is_alert}}\nplease check ${var.service-name} requests success rate !\n{{/is_alert}}\n\n{{#is_recovery}}\n${var.service-name} requests success rate has recovered !\n{{/is_recovery}}\n\nNotify: ${var.notification-list}"
  include_tags = true
  tags = ["team:${var.team}", "project:${var.project}", "service:${var.service-name}", "sucessrate", "sli"]
  notify_audit = true
  locked = true
  timeout_h = 0
  no_data_timeframe = null
  require_full_window = false
  new_host_delay = 300
  notify_no_data = false
  renotify_interval = 10
  escalation_message = "Attention: ${var.service-name} requests success rate has not yet recovered !!!\nplease do check !!!\n\nNotify: ${var.notification-list}"
  thresholds = {
    warning           = var.warning-threshold
    warning_recovery  = var.warning-recovery
    critical          = var.critical-threshold
    critical_recovery = var.critical-recovery
  }
}
