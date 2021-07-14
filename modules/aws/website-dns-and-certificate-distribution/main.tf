terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

data "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name
}

data "aws_route53_zone" "domain_zone" {
  name         = var.domain_name
  private_zone = false
}

data "aws_acm_certificate" "domain_certificate" {
  domain   = var.domain_name
}

resource "aws_cloudfront_origin_access_identity" "cloudfront_origin_access_id" {
  comment = "...bla bla..."
}

resource "aws_cloudfront_distribution" "s3_certificate_distribution" {

  origin {
    domain_name = data.aws_s3_bucket.website_bucket.bucket_domain_name
    origin_id   = "S3-${data.aws_s3_bucket.website_bucket.id}"
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cloudfront_origin_access_id.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "cloud distribution for s3"
  default_root_object = "index.html"
  aliases = [ var.domain_name ]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${data.aws_s3_bucket.website_bucket.id}"
    forwarded_values {
      query_string = false
      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  tags = {
    env = "dev"
  }

  viewer_certificate {
    ssl_support_method = "sni-only"
    acm_certificate_arn = data.aws_acm_certificate.domain_certificate.arn
    cloudfront_default_certificate = false
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

}

resource "aws_route53_record" "website-cname" {
  zone_id = data.aws_route53_zone.domain_zone.zone_id
  name    = var.domain_name
  type    = "A"

  depends_on = [aws_cloudfront_distribution.s3_certificate_distribution]
  alias {
    name                   = aws_cloudfront_distribution.s3_certificate_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_certificate_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

