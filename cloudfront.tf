resource "aws_cloudfront_distribution" "frontend" {
  origin {
    domain_name = aws_s3_bucket.frontend.website_domain
    origin_id   = local.domain

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_ssl_protocols = [
        "TLSv1",
        "TLSv1.1",
        "TLSv1.2"
      ]
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "GB"]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"
    target_origin_id       = local.domain

    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.frontend.arn
    ssl_support_method  = "sni-only"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = [local.domain]

  tags = {
    appname = var.appname
  }
}
