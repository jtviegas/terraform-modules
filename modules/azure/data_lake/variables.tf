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
variable "data_lake_fs_name" {
  type        = string
  default     = "staging"
  description = "name of the file system"
}
variable "data_lake_paths" {
  type    = set(string)
  description = "all the paths to create in root fs"
}



