#Create S3 bucket to store static content in
resource "aws_s3_bucket" "websiteBucket" {
  bucket = var.domainName

  tags = {
    Name        = "website Bucket"
    BuiltBy     = "Terraform"
  }
}

resource "aws_s3_bucket_acl" "websiteBucket_acl" {
  bucket = aws_s3_bucket.websiteBucket.id
  acl    = "private"
}

locals {
  s3_origin_id = "myS3Origin"
}

#Cloudfront Distribution
resource "aws_cloudfront_distribution" "website_distribution" {
  origin {
    domain_name              = aws_s3_bucket.websiteBucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.website_access_control.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = "websitelogs.s3.amazonaws.com"
  }
  

  aliases = ["stejackson.com"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/content/immutable/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/content/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  tags = {
    Name        = "website CF distribution"
    BuiltBy     = "Terraform"
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.website_cert
  }
}

resource "aws_cloudfront_origin_access_control" "website_access_control" {
  name                              = "website_access_control"
  description                       = "website access control policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

#ACM Cert
resource "aws_acm_certificate" "website_cert" {
  domain_name       = var.domainName
  validation_method = "DNS"
  provider = aws.virginia 

  tags = {
    Name        = "website cert"
    BuiltBy     = "Terraform"
  }

  lifecycle {
    create_before_destroy = true
  }
}