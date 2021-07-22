terraform {
  backend "s3" {
    bucket = "terraform-state-tgedr-tf-modules-test"
    key    = "domain-certificate"
    dynamodb_table = "terraform-state-lock-tgedr-tf-modules-test"
    region = "us-east-1"
  }
}

variable "domain" {
  type    = string
}

variable "sub_domains" {
  type    = set(string)
}

variable "region" {
  type    = string
}

provider "aws" {
  region  = var.region
}


module "domain_certificate" {
  source = "./modules/aws/domain-certificate"
  domain = var.domain
  sub_domains = var.sub_domains
}

output "id" {
  value       = module.domain_certificate.id
}

output "arn" {
  value       = module.domain_certificate.arn
}

