
variable "admin-public-key" {
  description = "admin public key to encrypt password, using keybase one"
  # string, number, bool, list, map, set, object, tuple, and any
  type        = string
   default     = "keybase:jtviegas"
}
