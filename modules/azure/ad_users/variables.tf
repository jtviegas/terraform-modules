
variable "users" {
  type = list(object({
      display_name = string
      password = string
      user_principal_name = string
    }))
}

