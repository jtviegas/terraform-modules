terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "solution" {
  type    = string
}

variable "region" {
  type    = string
}

provider "aws" {
  region  = var.region
}

module "remote_state" {
  source = "./modules/aws/remote-state"
  solution = var.solution
}

output "lock_state_table_arn" {
  value = module.remote_state.table_arn
}

output "lock_state_table_id" {
  value = module.remote_state.table_id
}

output "tf_state_bucket_arn" {
  value = module.remote_state.bucket_arn
}

output "tf_state_bucket_id" {
  value = module.remote_state.bucket_id
}