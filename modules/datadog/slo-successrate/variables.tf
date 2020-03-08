variable "service-name" {
  type        = string
  #default     = "dev"
}

variable "team" {
  type        = string
  #  default     = "team"
}

variable "project" {
  type        = string
#  default     = "project"
}

variable "target-threshold" {
  type        = number
  default     = 99.0
}

variable "warning-threshold" {
  type        = number
  default     = 99.5
}

