provider "aws" {
  region = var.region
}

variable "region" {
  type      = string
}

variable "bucket_name" {
  type        = string
}

variable "domain_name" {
  type        = string
}

variable "subdomain_name" {
  type        = string
}

module "s3_website_domain" {
  source = "./modules/aws/s3-website-subdomain"
  bucket_name = var.bucket_name
  domain_name = var.domain_name
  subdomain_name = var.subdomain_name
}
