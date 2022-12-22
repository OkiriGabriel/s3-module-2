module "s3_bucket" {
  source  = "../resource"
  bucket  = var.bucket

  acl = var.acl
  versioning          = true
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls 
  restrict_public_buckets = var.restrict_public_buckets
}