variable "bucket-name" {
  type        = string
  # default     = "..."
}

variable "function-role-name" {
  type        = string
  # default     = "..."
}

variable "function-artifact" {
  description = "the path to the function zip"
  type        = string
  # default     = "./function.zip"
}

variable "function-name" {
  type        = string
  # default     = "..."
}

variable "notification-name" {
  type        = string
  # default     = "..."
}

