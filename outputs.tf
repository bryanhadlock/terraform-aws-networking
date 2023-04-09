// Copyright (c) AvantGuard Monitoring Centers. All rights reserved.

output "ui_url" {
  value = aws_s3_bucket.agmonitoringbucket.website_endpoint
}