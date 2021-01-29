terraform {
  backend "s3" {
    bucket = "terraform-state-s3website"
    key    = "website"
    region = "eu-north-1"
    dynamodb_table = "terraform-state-lock-s3website"
  }
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

variable "index_html" {
  type        = string
}

provider "aws" {
  region  = var.region
}

module "s3_website_domain_bundled" {
  source = "./modules/aws/s3-website-domain-bundled"
  bucket_name = var.bucket_name
  domain_name = var.domain_name
  index_html  = var.index_html
}
