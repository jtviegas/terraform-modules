terraform {
  backend "s3" {
    bucket = "terraform-state-s3website"
    key    = "website"
    region = "eu-north-1"
  }
}

provider "aws" {
  region  = var.region
}

variable "region" {
  type    = string
}

variable "bucket_name" {
  type    = string
}

variable "domain_name" {
  type    = string
}

module "s3_website_domain" {
  source = "./modules/aws/s3-website-domain"
  bucket_name = var.bucket_name
  domain_name = var.domain_name
}
