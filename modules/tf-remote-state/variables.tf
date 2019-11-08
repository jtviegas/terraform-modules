variable "environment" {
  description = "the deployment environment"
  # dev | pro
  type        = string
  # default     = "dev"
}

variable "application" {
  description = "the application"
  # string, number, bool, list, map, set, object, tuple, and any
  type        = string
  # default     = "store"
}


