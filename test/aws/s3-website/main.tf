terraform {
  backend "s3" {
    bucket = "terraform-state-jettevisti"
    key    = "s3-website"
    region = "eu-north-1"
  }
}

provider "aws" {
  region = var.region
}

variable "region" {
  type      = string
}

variable "bucket_name" {
  type        = string
}

variable "index_html" {
  type        = string
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