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
variable "data_lake_store_suffix" {
  type        = string
  description = "name suffix to be added to 'project0solution0env0'"
}



