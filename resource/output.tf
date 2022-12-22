# Module      : S3 BUCKET
# Description : Terraform module to create default S3 bucket with logging and encryption
#               type specific features.

output "arn" {
  value       = aws_s3_bucket.s3_default.arn
  description = "The ARN of the s3 bucket."
}


# output "tags" {
#   value       = module.labels.tags
#   description = "A mapping of tags to assign to the resource."
# }