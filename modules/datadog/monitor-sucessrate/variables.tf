variable "service-name" {
  type        = string
  #default     = "dev"
}

variable "notification-list" {
  type        = string
#  default     = "@the.team @joao.viegas@maersk.com"
}

variable "team" {
  type        = string
  #  default     = "team"
}

variable "project" {
  type        = string
#  default     = "project"
}

variable "critical-threshold" {
  type        = number
  default     = 99.0
}

variable "critical-recovery" {
  type        = number
  default     = 99.1
}

variable "warning-threshold" {
  type        = number
  default     = 99.5
}

variable "warning-recovery" {
  type        = number
  default     = 99.6
}