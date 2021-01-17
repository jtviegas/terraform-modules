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
}

resource "aws_route53_zone" "subdomain_zone" {
  name         = var.subdomain_name
}



resource "aws_acm_certificate" "domain_certificate" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  subject_alternative_names = [ "*.${var.domain_name}" ]
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

resource "aws_cloudfront_origin_access_identity" "origin_access_id" {
  comment = "...bla bla..."
}

resource "aws_route53_record" "subdomain_record" {
  depends_on = [aws_route53_zone.subdomain_zone, aws_cloudfront_distribution.s3_cdn]
  zone_id = data.aws_route53_zone.domain_zone.zone_id
  name    = var.subdomain_name
  type    = "A"
   alias {
    name                   = aws_cloudfront_distribution.s3_cdn.domain_name
    zone_id                = aws_cloudfront_distribution.s3_cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_cloudfront_distribution" "s3_cdn" {

  depends_on = [aws_acm_certificate_validation.domain_certificate_validation, aws_cloudfront_origin_access_identity.origin_access_id, data.aws_s3_bucket.website_bucket ]


  enabled             = true
  default_root_object = "index.html"

  origin {
    domain_name = data.aws_s3_bucket.website_bucket.bucket_domain_name
    origin_id   = var.subdomain_name
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_id.cloudfront_access_identity_path
    }
  }

 viewer_certificate {
    ssl_support_method = "sni-only"
    acm_certificate_arn = aws_acm_certificate.domain_certificate.arn
    cloudfront_default_certificate = false
  }

  aliases = [ var.subdomain_name ]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.subdomain_name
    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  tags = {
    env = "dev"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}




/*

resource "aws_acm_certificate" "domain_certificate" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  subject_alternative_names = [ "*.${var.domain_name}" ]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "domain_record" {
  depends_on = [aws_acm_certificate.domain_certificate]
  name    = tolist(aws_acm_certificate.domain_certificate.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.domain_certificate.domain_validation_options)[0].resource_record_type
  zone_id = data.aws_route53_zone.domain_zone.id
  records = [ tolist(aws_acm_certificate.domain_certificate.domain_validation_options)[0].resource_record_value ]
  ttl     = 2400
}

resource "aws_acm_certificate_validation" "domain_certificate_validation" {
  depends_on = [aws_route53_record.domain_record]
  certificate_arn         = aws_acm_certificate.domain_certificate.arn
  validation_record_fqdns = [ aws_route53_record.domain_record.fqdn ]
}


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
