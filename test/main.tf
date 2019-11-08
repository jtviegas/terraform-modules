variable "app" {
  type        = string
  default     = "store"
}

variable "env" {
  type        = string
  default     = "dev"
}

provider "aws" {
  version = "~> 2.33"
  region = "eu-west-1"
}

module "bucket-event-handling" {
  source = "../bucket-event-handling"
  
  bucket-name = "${var.app}-${var.env}-bucket"
  table-name = "${var.app}-${var.env}-parts"
  function-role-name = "${var.app}-${var.env}-function-role"
  function-artifact = "../../store-loader/src/store-loader.zip"
  function-name = "${var.app}-${var.env}-function"
  notification-name = "${var.app}-${var.env}-statement"

}
