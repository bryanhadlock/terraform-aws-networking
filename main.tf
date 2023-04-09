// Copyright (c) AvantGuard Monitoring Centers. All rights reserved.

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
    archive = {
      source  = "hashicorp/archive"
    }
  }
}

locals {
  build_output_path = "../dist/${var.projectname}"
}

resource "local_file" "set_environment" {
  content =  "${var.settingsjson}" 
  filename = "${local.build_output_path}/assets/settings.json"
}

resource "aws_s3_bucket" "agmonitoringbucket" {
  bucket = "${var.username}${var.username == "" ? "" : "-"}agmonitoring-test-state"
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "website_routing" {
  bucket = aws_s3_bucket.agmonitoringbucket.id

  index_document {
    suffix = "index.html"
  }

  routing_rule {
    condition {
      http_error_code_returned_equals = 404
    }
    redirect {
      replace_key_with = "index.html"
    }
  }
}

resource "aws_s3_object" "js_upload" {
  for_each = fileset("${local.build_output_path}/", "*.js")
  bucket = aws_s3_bucket.agmonitoringbucket.id
  acl    = "public-read"
  key    = each.value
  content_disposition = "inline"
  content_type = "text/javascript"

  source = "${local.build_output_path}/${each.value}" 
}

resource "aws_s3_object" "html_upload" {
  for_each = fileset("${local.build_output_path}/", "*.html")
  bucket = aws_s3_bucket.agmonitoringbucket.id
  acl    = "public-read"
  key    = each.value
  content_disposition = "inline"
  content_type = "text/html"

  source = "${local.build_output_path}/${each.value}" 
}

resource "aws_s3_object" "css_upload" {
  for_each = fileset("${local.build_output_path}/", "*.css")
  bucket = aws_s3_bucket.agmonitoringbucket.id
  acl    = "public-read"
  key    = each.value
  content_disposition = "inline"
  content_type = "text/css"

  source = "${local.build_output_path}/${each.value}" 
}

resource "aws_s3_object" "svg_upload" {
  for_each = fileset("${local.build_output_path}/assets/", "*.svg")
  bucket = aws_s3_bucket.agmonitoringbucket.id
  acl    = "public-read"
  key    = "assets/${each.value}"
  content_disposition = "inline"
  content_type = "image/svg+xml"

  source = "${local.build_output_path}/assets/${each.value}" 
}

resource "aws_s3_object" "json_upload" {
  depends_on = [
    local_file.set_environment
  ]
  for_each = fileset("${local.build_output_path}/assets/", "*.json")
  bucket = aws_s3_bucket.agmonitoringbucket.id
  acl    = "public-read"
  key    = "assets/${each.value}"
  content_disposition = "inline"
  content_type = "text/json"
  
  source = "${local.build_output_path}/assets/${each.value}" 
}