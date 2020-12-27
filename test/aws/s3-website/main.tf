provider "aws" {
  region = var.region
}

variable "region" {
  type      = string
}

variable "bucket_name" {
  type        = string
}

variable "bucket_content_dir" {
  type        = string
}


module "s3_website" {
  source = "./modules/aws/s3-website"
  bucket_name = var.bucket_name
  bucket_content_dir = var.bucket_content_dir
}

output "arn" {
  value = module.s3_website.arn
}

output "endpoint" {
  value = module.s3_website.endpoint
}

output "domain" {
  value       = module.s3_website.domain
}