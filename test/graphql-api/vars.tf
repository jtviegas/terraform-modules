variable "api" {
  type        = string
  default     = "graphql-test"
}

variable "environment" {
  type        = string
  default     = "dev"
}

variable "function" {
  type        = string
  default     = "helloworld"
}

variable "region" {
  type        = string
  default     = "eu-west-1"
}

variable "function-artifact-location" {
  type        = string
  default     = "helloworld.zip"
}

variable "function-runtime" {
  type        = string
  default     = "nodejs12.x"
}

variable "function-memory" {
  type        = number
  default     = 512
}

variable "function-timeout" {
  type        = number
  default     = 30
}

variable "accountid" {
  type        = string
  # default     = "..."
}
