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
  default     = 0.990
}

variable "critical-recovery" {
  type        = number
  default     = 0.991
}

variable "warning-threshold" {
  type        = number
  default     = 0.995
}

variable "warning-recovery" {
  type        = number
  default     = 0.996
}