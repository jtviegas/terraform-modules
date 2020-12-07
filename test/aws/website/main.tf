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

module "website" {
  source = "./modules/aws/website"
  bucket_name = var.bucket_name
  subdomain_name = var.subdomain_name
  domain_name = var.domain_name
}

output "arn" {
  value = module.website.arn
}

output "endpoint" {
  value = module.website.endpoint
}
