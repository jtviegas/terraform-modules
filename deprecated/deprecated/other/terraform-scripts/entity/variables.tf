variable "app" {
  type        = string
}

variable "env" {
  type        = string
  #default     = "dev|pro"
}

variable "region" {
  type        = string
  default     = "eu-west-1"
}

variable "accountid" {
  type        = string
}

variable "tables" {
  description = "tables to be created as part of the app, format: app-env-entity"
  type        = list(string)
  default     = ["testapp-dev-entity1"]
}


