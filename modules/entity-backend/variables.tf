variable "app" {
  type        = string
  # default     = "..."
}

variable "environment" {
  type        = string
  # default     = "..."
}

variable "loader-function-artifact" {
  description = "the path to the loader function zip"
  type        = string
  # default     = "./function.zip"
}

variable "region" {
  type        = string
  # default     = "eu-west-1"
}

variable "account-id" {
  type        = string
  # default     = "..."
}

variable "api-function-artifact" {
  description = "the path to the api function zip"
  type        = string
  # default     = "./function.zip"
}

variable "tables" {
  description = "tables to be created as part of the app"
  type        = list(string)
 #  default     = ["${app}-${env}-${entity1}", "${app}-${env}-${entity2}", "${app}-${env}-${entity3}"]
}