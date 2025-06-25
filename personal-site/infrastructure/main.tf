#Create S3 bucket to store static content in
resource "aws_s3_bucket" "websiteBucket" {
  bucket              = "stejackson.com"
  bucket_prefix       = null
  force_destroy       = null
  object_lock_enabled = false
  tags = {
    Name        = "website s3 bucket"
    BuiltBy     = "Terraform"
  }
}

# #Cloudfront Distribution
resource "aws_cloudfront_distribution" "website_distribution" {
  aliases                         = [var.domainName]
  comment                         = null
  continuous_deployment_policy_id = null
  default_root_object             = "index.html"
  enabled                         = true
  http_version                    = "http2"
  is_ipv6_enabled                 = false
  price_class                     = "PriceClass_All"
  retain_on_delete                = false
  staging                         = false
  tags = {
    Name        = "website cloudfront distribution"
    BuiltBy     = "Terraform"
  }
  wait_for_deployment             = true
  web_acl_id                      = null
  default_cache_behavior {
    allowed_methods            = ["GET", "HEAD"]
    cache_policy_id            = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    cached_methods             = ["GET", "HEAD"]
    compress                   = true
    default_ttl                = 0
    field_level_encryption_id  = null
    max_ttl                    = 0
    min_ttl                    = 0
    origin_request_policy_id   = null
    realtime_log_config_arn    = null
    response_headers_policy_id = null
    smooth_streaming           = false
    target_origin_id           = aws_s3_bucket.websiteBucket.id
    trusted_key_groups         = []
    trusted_signers            = []
    viewer_protocol_policy     = "allow-all"
    grpc_config {
      enabled = false
    }
  }
  origin {
    connection_attempts      = 3
    connection_timeout       = 10
    domain_name              = aws_s3_bucket.websiteBucket.id
    origin_access_control_id = null
    origin_id                = aws_s3_bucket.websiteBucket.id
    origin_path              = null
    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_ssl_protocols     = ["TLSv1.3", "TLSv1.2"]
    }
  }
  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn            = aws_acm_certificate.website_cert.arn
    cloudfront_default_certificate = false
    iam_certificate_id             = null
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }
  depends_on = [ aws_acm_certificate.website_cert ]
}

# #ACM Cert
resource "aws_acm_certificate" "website_cert" {
  provider                  = aws.virginia
  certificate_authority_arn = null
  certificate_body          = null
  certificate_chain         = null
  domain_name               = var.domainName
  early_renewal_duration    = null
  key_algorithm             = "RSA_2048"
  private_key               = null # sensitive
  subject_alternative_names = [var.domainName]
  tags = {
    Name        = "website ACM cert"
    BuiltBy     = "Terraform"
  }
  validation_method         = "DNS"
  options {
    certificate_transparency_logging_preference = "ENABLED"
  }
}