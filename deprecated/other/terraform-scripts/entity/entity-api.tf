provider "aws" {
  version = "~> 2.33"
  region = "${var.region}"
}

module "entity-api" {
  source = "./modules/entity-api"
  environment = "${var.env}"
  api-name = "${var.app}"
  region = "${var.region}"
  account-id = "${var.accountid}"
  lambda-artifact = "./entity-api.zip"
}

terraform {
  backend "s3" {
    bucket         = "$APP-$ENV-terraform-state"
    key            = "entity-api/terraform.tfstate"
    region         = "$REGION"
    dynamodb_table = "$APP-$ENV-terraform-state-lock"
    encrypt        = true
  }
}

output "url" {
  value       = module.entity-api.invoke-url
}


