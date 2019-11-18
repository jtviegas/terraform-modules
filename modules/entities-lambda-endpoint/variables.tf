variable "region" {
  type        = string
  # default     = "..."
}

variable "account-id" {
  type        = string
  # default     = "..."
}

variable "environment" {
  type        = string
  # default     = "..."
}

variable "api-name" {
  type        = string
  # default     = "..."
}

variable "lambda-name" {
  type        = string
  # default     = "..."
}

variable "lambda-artifact" {
  type        = string
  # default     = "..."
}

variable "lambda-role" {
  type        = string
  # default     = "..."
}

variable "lambda-role-policy" {
  type        = string
  # default     = "..."
}

variable "tables" {
  description = "tables to be created as part of the app"
  type        = list(string)
  # default     = ["neo", "trinity", "morpheus"]
}
