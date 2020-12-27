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
  for_each = fileset(var.bucket_content_dir, "*")
  bucket = aws_s3_bucket.website_bucket.id
  key = each.value
  source = "${var.bucket_content_dir}/${each.value}"
  etag = filemd5("${var.bucket_content_dir}/${each.value}")
  acl    = "public-read"
}

