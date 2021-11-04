variable "project" {
  type        = string
}
variable "solution" {
  type        = string
}
variable "env" {
  type        = string
}
variable "location" {
  type        = string
  default     = "West Europe"
}
variable "storage_account_suffix" {
  type        = string
  description = "storage suffix to be added to 'project0solution0env0'"
}

variable "container_name" {
  type        = string
  description = "container name"
}

