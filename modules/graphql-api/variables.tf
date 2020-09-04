variable "api" {
  type        = string
  # default     = "app"
}

variable "environment" {
  type        = string
  # default     = "dev"
}

variable "function" {
  type        = string
  # default     = "dev"
}

variable "region" {
  type        = string
  # default     = "eu-west-1"
}

variable "function-artifact-location" {
  type        = string
  # default     = "..."
}

variable "function-runtime" {
  type        = string
  # default     = "nodejs8.10"
}

variable "function-memory" {
  type        = number
  # default     = 1024
}

variable "function-timeout" {
  type        = number
  # default     = 60
}

