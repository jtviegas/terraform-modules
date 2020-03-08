variable "service-name" {
  type        = string
  #default     = "dev"
}

variable "monitor-id" {
  type        = string
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
  default     = 99.8
}

variable "warning-threshold" {
  type        = number
  default     = 99.9
}

