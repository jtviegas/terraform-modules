variable "devops_identity_group" {type = string}
variable "devops_identity_user" {type = string}
variable "region" {type = string}

provider "aws" {
  region  = var.region
}

module "devops_identity" {
  source = "./modules/aws/devops_identity"
  devops_identity_group = var.devops_identity_group
  devops_identity_user = var.devops_identity_user
  custom_policy = jsonencode(
    {
      "Statement": [ 
          { "Action": [ "amplify:GetJob", "amplify:ListArtifacts", "amplify:ListJobs" ], 
          "Effect": "Allow",
          "Resource": "*",
          "Sid": "VisualEditor01"}
          ],
      "Version": "2012-10-17"
    }
  )
}

output "access_key_id" {
  value = module.devops_identity.user_devops_identity_access_key_id
}

output "access_key" {
  value = module.devops_identity.user_devops_identity_access_key
  sensitive = true
}
