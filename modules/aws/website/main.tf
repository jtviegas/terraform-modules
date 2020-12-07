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



/*

data "aws_route53_zone" "zone" {
  name         = "${var.domain-name}."
  private_zone = false
}

resource "aws_acm_certificate" "domain-certificate" {
  domain_name       = "${var.domain-name}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "domain-record" {
  depends_on = [aws_s3_bucket.website-bucket, aws_acm_certificate.domain-certificate]
  name    = "${aws_acm_certificate.domain-certificate.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.domain-certificate.domain_validation_options.0.resource_record_type}"
  zone_id = "${data.aws_route53_zone.zone.id}"
  records = ["${aws_acm_certificate.domain-certificate.domain_validation_options.0.resource_record_value}"]
  ttl     = 2400
}

resource "aws_acm_certificate_validation" "domain-validation" {
  depends_on = [aws_route53_record.domain-record]
  certificate_arn         = "${aws_acm_certificate.domain-certificate.arn}"
  validation_record_fqdns = ["${aws_route53_record.domain-record.fqdn}"]
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "Some comment"
}

resource "aws_cloudfront_distribution" "s3_distribution" {

  depends_on = [aws_acm_certificate_validation.domain-validation, aws_cloudfront_origin_access_identity.origin_access_identity]

  origin {
    domain_name = "${aws_s3_bucket.website-bucket.bucket_domain_name}"
    origin_id   = "S3-${aws_s3_bucket.website-bucket.id}"
    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "cloud distribution for s3-certificate"
  default_root_object = "index.html"
  aliases = ["${var.domain-name}"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.website-bucket.id}"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
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
    acm_certificate_arn = "${aws_acm_certificate.domain-certificate.arn}"
    cloudfront_default_certificate = false
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

}

resource "aws_route53_record" "website-cname" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "${var.domain-name}"
  type    = "A"

  depends_on = [aws_cloudfront_distribution.s3_distribution]
  #records        = ["${aws_cloudfront_distribution.s3_distribution.domain_name}"]
  alias {
    name                   = "${aws_cloudfront_distribution.s3_distribution.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.s3_distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}

*/
