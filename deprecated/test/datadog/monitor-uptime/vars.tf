variable "datadog_api_key" {
  type        = string
  #  default     = "dev"
}
variable "datadog_app_key" {
  type        = string
  #  default     = "team"
}
variable "datadog_url" {
  type        = string
  default     = "https://api.datadoghq.eu/"
}
variable "service-name" {
  type        = string
  default     = "api-service"
}
variable "team" {
  type        = string
  default     = "penny"
}
variable "project" {
  type        = string
  default     = "knapsack"
}
variable "notification-list" {
  type        = string
  default     = "@joao.viegas@maersk.com"
}
