provider "datadog" {
  api_key = "${var.datadog_api_key}"
  app_key = "${var.datadog_app_key}"
  api_url = "https://api.datadoghq.eu/"
}

terraform {
  backend "azurerm" {
    storage_account_name  = "knapsack0dev0tfstate"
    container_name        = "knapsack0dev0tfstate"
    key                   = "knapsack0dev"
  }
}

resource "datadog_monitor" "api-successrate" {
  name               = "api service => sucess rate 2"
  type               = "query alert"
  query = "avg(last_5m):sum:trace.servlet.request.hits.by_http_status{http.status_class:2xx,service:penny-knapsack-api}.as_count() / sum:trace.servlet.request.hits.by_http_status{service:penny-knapsack-api}.as_count() < 0.95"
  message            = "{{#is_alert}}\nplease check api service requests success rate !\n{{/is_alert}}\n{{#is_recovery}}\napi service requests success rate has recovered !\n{{/is_recovery}}\nNotify: @joao.viegas@maersk.com"
  include_tags = true
  tags = ["team:penny", "app:knapsack", "api:api", "sucessRate"]
  notify_audit = true
  locked = true
  timeout_h = 0
  silenced = {}
  no_data_timeframe = 5
  require_full_window = false
  new_host_delay = 300
  notify_no_data = false
  renotify_interval = 10
  escalation_message = "Attention: api service requests success rate has not yet recovered !!!\nplease do check !!!\nNotify: @joao.viegas@maersk.com"
  thresholds = {
    ok                = 0.99
    warning           = 0.97
    warning_recovery  = 0.98
    critical          = 0.95
    critical_recovery = 0.96
  }
}

resource "datadog_monitor" "api-uptime" {
  name               = "api service => uptime 2"
  type               = "query alert"
  query = "avg(last_1m):min:kubernetes.pods.running{kube_service:api-service}.fill(zero, 60) < 0.99"
  message            = "{{#is_alert}}\nplease check api service instance count !\n{{/is_alert}}\n{{#is_recovery}}\napi service instance count has recovered !\n{{/is_recovery}}\n\nNotify: @joao.viegas@maersk.com"
  include_tags = true
  tags = ["team:penny", "app:knapsack", "api:api", "uptime"]
  notify_audit = true
  locked = true
  timeout_h = 0
  silenced = {}
  no_data_timeframe = 5
  require_full_window = true
  new_host_delay = 300
  notify_no_data = true
  renotify_interval = 10
  escalation_message = "Attention: api service instance count has not yet recovered !!!\nplease do check !!!\n\nNotify: @joao.viegas@maersk.com"
  thresholds = {
    warning           = 1.99
    warning_recovery  = 2
    critical          = 0.99
    critical_recovery = 1
  }
}

resource "datadog_monitor" "solver-successrate" {
  name               = "solver service => sucess rate 2"
  type               = "query alert"
  query = "avg(last_5m):sum:trace.servlet.request.hits.by_http_status{http.status_class:2xx,service:penny-knapsack-solver}.as_count() / sum:trace.servlet.request.hits.by_http_status{service:penny-knapsack-solver}.as_count() < 0.95"
  message            = "{{#is_alert}}\nplease check solver service requests success rate !\n{{/is_alert}}\n{{#is_recovery}}\nsolver service requests success rate has recovered !\n{{/is_recovery}}\nNotify: @joao.viegas@maersk.com"
  include_tags = true
  tags = ["team:penny", "app:knapsack", "api:solver", "sucessRate"]
  notify_audit = true
  locked = true
  timeout_h = 0
  silenced = {}
  no_data_timeframe = 5
  require_full_window = false
  new_host_delay = 300
  notify_no_data = false
  renotify_interval = 10
  escalation_message = "Attention: solver service requests success rate has not yet recovered !!!\nplease do check !!!\nNotify: @joao.viegas@maersk.com"
  thresholds = {
    ok                = 0.99
    warning           = 0.97
    warning_recovery  = 0.98
    critical          = 0.95
    critical_recovery = 0.96
  }
}

resource "datadog_monitor" "solver-uptime" {
  name               = "solver service => uptime 2"
  type               = "query alert"
  query = "avg(last_1m):min:kubernetes.pods.running{kube_service:solver-service}.fill(zero, 60) < 0.99"
  message            = "{{#is_alert}}\nplease check solver service instance count !\n{{/is_alert}}\n{{#is_recovery}}\nsolver service instance count has recovered !\n{{/is_recovery}}\n\nNotify: @joao.viegas@maersk.com"
  include_tags = true
  tags = ["team:penny", "app:knapsack", "api:solver", "uptime"]
  notify_audit = true
  locked = true
  timeout_h = 0
  silenced = {}
  no_data_timeframe = 5
  require_full_window = true
  new_host_delay = 300
  notify_no_data = true
  renotify_interval = 10
  escalation_message = "Attention: solver service instance count has not yet recovered !!!\nplease do check !!!\n\nNotify: @joao.viegas@maersk.com"
  thresholds = {
    warning           = 1.99
    warning_recovery  = 2
    critical          = 0.99
    critical_recovery = 1
  }
}