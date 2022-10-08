terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_acl" "website_bucket" {
  bucket = aws_s3_bucket.website_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "website_bucket" {
  bucket = aws_s3_bucket.website_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}

resource "aws_s3_object" "website_content" {
  bucket = aws_s3_bucket.website_bucket.id
  key = "index.html"
  source = var.index_html
  acl    = "public-read"
  content_type = "text/html"
  storage_class = "STANDARD"
  etag = filemd5(var.index_html)
}

