terraform {
  backend "s3" {
    bucket = "terraform-state-tgedr-tf-modules-test"
    key    = "website-dns-and-certificate-distribution"
    dynamodb_table = "terraform-state-lock-tgedr-tf-modules-test"
    region = "us-east-1"
  }
}

variable "bucket_name" {
  type    = string
}

variable "domain_name" {
  type    = string
}

variable "region" {
  type    = string
}

provider "aws" {
  region  = var.region
}

module "website_dns_and_certificate_distribution" {
  source = "./modules/aws/website-dns-and-certificate-distribution"
  bucket_name = var.bucket_name
  domain_name = var.domain_name
}
