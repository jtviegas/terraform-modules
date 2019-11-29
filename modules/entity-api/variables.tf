variable "api-name" {
  type        = string
  # default     = "app"
}

variable "environment" {
  type        = string
  # default     = "dev"
}

variable "region" {
  type        = string
  # default     = "eu-west-1"
}

variable "account-id" {
  type        = string
  # default     = "..."
}

variable "lambda-artifact" {
  type        = string
  # default     = "..."
}

#variable "tables" {
#  description = "tables to be created as part of the app"
#  type        = list(string)
  # default     = ["neo", "trinity", "morpheus"]
#}
