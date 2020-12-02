
variable "user_public_key" {
  description = "Either a base-64 encoded PGP public key, or a keybase username in the form keybase:username"
  type        = string
}

variable "user_name" {
  type        = string
}

variable "group_name" {
  type        = string
}