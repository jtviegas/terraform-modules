provider "aws" {
  version = "~> 2.33"
  region = "${var.region}"
}

module "entity-loader" {
  source = "./modules/entity-loader"
  environment = "${var.env}"
  app = "${var.app}"
  function-artifact = "./entity-loader.zip"
}

terraform {
  backend "s3" {
    bucket         = "$APP-$ENV-terraform-state"
    key            = "entity-loader/terraform.tfstate"
    region         = "$REGION"
    dynamodb_table = "$APP-$ENV-terraform-state-lock"
    encrypt        = true
  }
}

