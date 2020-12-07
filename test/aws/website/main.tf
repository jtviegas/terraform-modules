variable "region" {
  type      = string
}

variable "bucket_name" {
  type        = string
}

provider "aws" {
  region = var.region
}

module "website" {
  source = "./modules/aws/website"
  bucket_name = var.bucket_name
}

output "arn" {
  value = module.website.arn
}

output "endpoint" {
  value = module.website.endpoint
}
