variable "project" {
  description = "umbrella account where to create resources"
  type        = string
}
variable "admin-public-key" {
  description = "admin public key to encrypt password, using keybase one"
  type        = string
  # default     = "keybase:jtviegas"
}
