variable "app" {
  type        = string
  # default     = "..."
}

variable "environment" {
  type        = string
  # default     = "..."
}

variable "function-artifact" {
  description = "the path to the function zip"
  type        = string
  # default     = "./function.zip"
}
