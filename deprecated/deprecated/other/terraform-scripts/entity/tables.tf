provider "aws" {
  version = "~> 2.33"
  region = "${var.region}"
}

module "tables" {
    source = "./modules/simple-tables"
    names     = var.tables
}

terraform {
  backend "s3" {
    bucket         = "$APP-$ENV-terraform-state"
    key            = "tables/terraform.tfstate"
    region         = "$REGION"
    dynamodb_table = "$APP-$ENV-terraform-state-lock"
    encrypt        = true
  }
}

