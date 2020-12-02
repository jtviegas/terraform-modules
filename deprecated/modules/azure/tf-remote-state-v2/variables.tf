variable "env" {
  type        = string
#  default     = "dev"
}
variable "team" {
  type        = string
#  default     = "team"
}
variable "project" {
  type        = string
#  default     = "project"
}
variable "app" {
  type        = string
  #default     = "app"
}

variable "storage-account-name" {
  type        = string
  #default     = "dev"
}
variable "storage-container-name" {
  type        = string
  #default     = "dev"
}
variable "resource-group-name" {
  type        = string
}
variable "resource-group-region" {
  type        = string
}