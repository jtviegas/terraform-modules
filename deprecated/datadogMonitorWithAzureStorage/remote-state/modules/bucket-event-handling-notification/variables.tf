variable "bucket-id" {
  description = "the bucket id"
  type        = string
  # default     = "bck1"
}

variable "bucket-arn" {
  description = "the bucket arn"
  type        = string
  # default     = "aws:*:::bck1"
}

variable "function-arn" {
  description = "the function arn"
  type        = string
  # default     = "aws:*:::thefunc"
}

variable "function-name" {
  description = "the function name"
  type        = string
  # default     = "thefunc"
}

variable "notification-name" {
  description = "used to define the statement id"
  type        = string
  # default     = "xpto"
}



