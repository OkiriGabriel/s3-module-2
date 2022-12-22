# module "s3_bucket" {
#   source  = "terraform-aws-modules/s3-bucket/aws"
#   version = "3.6.0"
#   bucket  = var.bucket

#   acl = var.acl
#   versioning = {
#     enabled = true
#   }
  
#   block_public_acls       = var.block_public_acls
#   block_public_policy     = var.block_public_policy
#   ignore_public_acls      = var.ignore_public_acls 
#   restrict_public_buckets = var.restrict_public_buckets
# }


#Create s3 bucket
resource "aws_s3_bucket" "s3_default" {
  bucket        = var.bucket
  force_destroy = var.force_destroy
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }


  dynamic "object_lock_configuration" {
    for_each = var.object_lock_configuration != null ? [1] : []

    content {
      object_lock_enabled = "Enabled"
    }
  }
}

#creates policy for S3 bucket on AWS
# resource "aws_s3_bucket_policy" "s3_default" {

#   bucket = aws_s3_bucket.s3_default.id
#   policy = var.aws_iam_policy_document
# }



#Enable bucket versioning
resource "aws_s3_bucket_versioning" "example" {
  bucket = aws_s3_bucket.s3_default.id
  versioning_configuration {
    status = "Enabled"
  }
}

#Enable bucket access logging level
resource "aws_s3_bucket_logging" "example" {
  bucket = aws_s3_bucket.s3_default.id
  target_bucket = aws_s3_bucket.s3_default.id
  target_prefix = var.target_prefix
  count  = var.logging == true ? 1 : 0
}

#enable bucket server side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.s3_default.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.enable_kms == true ? "aws:kms" : var.sse_algorithm
      kms_master_key_id = var.kms_master_key_id
    }
  }
}

locals {
  acl_grants = var.grants == null ? var.acl_grants : flatten(
    [
      for g in var.grants : [
        for p in g.permissions : {
          id         = g.id
          type       = g.type
          permission = p
          uri        = g.uri
        }
      ]
  ])
}

locals {
  create_bucket = var.create_bucket 
  # Variables with type `any` should be jsonencode()'d when value is coming from Terragrunt
  grants               = try(jsondecode(var.grants), var.grants)
}

resource "aws_s3_bucket_acl" "default" {
  count = local.create_bucket && ((var.acl != null && var.acl != "null") || length(local.grants) > 0) ? 1 : 0
  bucket = aws_s3_bucket.s3_default.id
  acl = try(length(local.acl_grants), 0) == 0 ? var.acl : null

  dynamic "access_control_policy" {
    for_each = try(length(local.acl_grants), 0) == 0 || try(length(var.acl), 0) > 0 ? [] : [1]

    content {
      dynamic "grant" {
        for_each = local.acl_grants

        content {
          grantee {
            id   = grant.value.id
            type = grant.value.type
            uri  = grant.value.uri
          }
          permission = grant.value.permission
        }
      }

      owner {
        id = var.owner_id
      }
    }
  }
}

#tfsec:ignore:aws-s3-block-public-acls
resource "aws_s3_bucket_public_access_block" "non_public_access" {
  bucket = aws_s3_bucket.s3_default.id
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}