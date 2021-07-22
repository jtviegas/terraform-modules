terraform {
  backend "s3" {
    bucket = "terraform-state-tgedr-tf-modules-test"
    key    = "test-3-apps-deployment"
    dynamodb_table = "terraform-state-lock-tgedr-tf-modules-test"
    region = "us-east-1"
  }
}

variable "region" {
  type    = string
}

provider "aws" {
  region  = var.region
}

variable "domain" {
  type    = string
}

variable "sub_domains" {
  type    = set(string)
}

module "subdomains" {
  for_each = var.sub_domains
  source = "./modules/aws/subdomain"
  domain = var.domain
  sub_domain = each.value
}

module "domain_certificate" {
  source = "./modules/aws/domain-certificate"
  domain = var.domain
  sub_domains = var.sub_domains
}

variable "buckets" {
  type = set(string)
}

variable "buckets_content" {
  type = map(string)
}

module "s3_websites" {
  for_each = var.buckets
  source = "./modules/aws/s3-website"
  bucket_name = each.value
  index_html = var.buckets_content[each.value]
}

variable "buckets_domain" {
  type = map(string)
}

module "web_distribution" {
  for_each = var.buckets
  source = "./modules/aws/web-distribution"
  bucket_name = each.value
  domain_name = var.buckets_domain[each.value]
  certificate_domain_name = var.domain
}