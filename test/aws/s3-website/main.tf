terraform {
  backend "s3" {
    bucket = "terraform-state-tgedr-tf-modules-test"
    dynamodb_table = "terraform-state-lock-tgedr-tf-modules-test"
    key    = "s3-website"
    region = "us-east-1"
  }
}

variable "region" {
  type    = string
}

variable "bucket_name" {
  type        = string
}

variable "index_html" {
  type        = string
}

provider "aws" {
  region  = var.region
}

module "s3_website" {
  source = "./modules/aws/s3-website"
  bucket_name = var.bucket_name
  index_html = var.index_html
}

output "arn" {
  value = module.s3_website.arn
}

output "endpoint" {
  value = module.s3_website.endpoint
}

output "domain" {
  value = module.s3_website.domain
}