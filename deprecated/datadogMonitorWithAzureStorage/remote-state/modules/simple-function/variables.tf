variable "artifact" {
  description = "the path to the function zip"
  # string, number, bool, list, map, set, object, tuple, and any
  type        = string
  # default     = "./function.zip"
}

variable "name" {
  description = "the function name"
  type        = string
  # default     = "func-x"
}

variable "role-arn" {
  description = "the role arn for the function"
  type        = string
  # default     = "aws:::::*"
}

