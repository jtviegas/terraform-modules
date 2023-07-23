variable "devops_identity_group" {type = string}
variable "devops_identity_user" {type = string}

module "devops_identity" {
  source = "./modules/aws/devops_identity"
  devops_identity_group = var.devops_identity_group
  devops_identity_user = var.devops_identity_user
}

output "password" {
  value = module.devops_identity.user_devops_identity_password
}

output "access_key" {
  value = module.devops_identity.user_devops_identity_access_key
  sensitive = true
}

output "access_key_id" {
  value = module.devops_identity.user_devops_identity_access_key_id
}
