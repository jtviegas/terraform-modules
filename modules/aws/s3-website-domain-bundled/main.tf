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

data "aws_route53_zone" "domain_zone" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_acm_certificate" "domain_certificate" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "domain_record" {
  depends_on = [aws_acm_certificate.domain_certificate]
  name    = "${tolist(aws_acm_certificate.domain_certificate.domain_validation_options)[0].resource_record_name}"
  type    = "${tolist(aws_acm_certificate.domain_certificate.domain_validation_options)[0].resource_record_type}"
  zone_id = data.aws_route53_zone.domain_zone.id
  records = [ "${tolist(aws_acm_certificate.domain_certificate.domain_validation_options)[0].resource_record_value}" ]
  ttl     = 2400
}


resource "aws_acm_certificate_validation" "domain_certificate_validation" {
  depends_on = [aws_route53_record.domain_record]
  certificate_arn         = aws_acm_certificate.domain_certificate.arn
  validation_record_fqdns = [ aws_route53_record.domain_record.fqdn ]
}


resource "aws_cloudfront_origin_access_identity" "cloudfront_origin_access_id" {
  comment = "...bla bla..."
}

resource "aws_cloudfront_distribution" "s3_certificate_distribution" {

  depends_on = [aws_acm_certificate_validation.domain_certificate_validation, aws_cloudfront_origin_access_identity.cloudfront_origin_access_id, aws_s3_bucket.website_bucket ]

  origin {
    domain_name = aws_s3_bucket.website_bucket.website_domain
    origin_id   = "S3-${aws_s3_bucket.website_bucket.id}"
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "cloud distribution for s3"
  default_root_object = "index.html"
  aliases = [ var.domain_name ]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.website_bucket.id}"
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
    acm_certificate_arn = aws_acm_certificate.domain_certificate.arn
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








/*

resource "aws_route53_zone" "subdomain" {
  name = "${var.subdomain_name}.${var.domain_name}"
}

resource "aws_route53_record" "subdomain" {
  allow_overwrite = true
  name            = "${var.subdomain_name}.${var.domain_name}"
  type            = "NS"
  zone_id         = aws_route53_zone.subdomain.zone_id

  depends_on = [aws_cloudfront_distribution.s3_certificate_distribution]
  #records        = ["${aws_cloudfront_distribution.s3_certificate_distribution.domain_name}"]
  alias {
    name                   = aws_cloudfront_distribution.s3_certificate_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_certificate_distribution.hosted_zone_id
    evaluate_target_health = false
  }

}

*/
