terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name
  acl    = "public-read"
  force_destroy = true

  website {
    index_document = "index.html"
  }

}

resource "aws_s3_bucket_object" "website_content" {
  bucket = aws_s3_bucket.website_bucket.id
  key = "index.html"
  source = var.index_html
  acl    = "public-read"
  content_type = "text/html"
  storage_class = "STANDARD"
  etag = filemd5("index.html")
  force_destroy = true
}

