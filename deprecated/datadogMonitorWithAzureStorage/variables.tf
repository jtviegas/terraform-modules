variable "app" {
  type        = string
  default     = "knapsack"
}

variable "env" {
  type        = string
  default     = "dev"
}

variable "resource-group" {
  type        = string
  default     = "rgpazewdmlit001pennydev02"
}

variable "region" {
  type        = string
  default     = "West Europe"
}

variable "datadog_api_key" {
  type        = string
}

variable "datadog_app_key" {
  type        = string
}
