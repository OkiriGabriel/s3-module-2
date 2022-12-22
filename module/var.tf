#Module      : LABEL
#Description : Terraform label module variables.
variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "bucket" {
  type        = string
  default     = "test00990"
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "tags" {
  type        = map(any)
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)."
}

# Module      : S3 BUCKET
# Description : Terraform S3 Bucket module variables.


variable "versioning" {
  type        = bool
  default     = true
  description = "Enable Versioning of S3."
}

variable "acl" {
  type        = string
  default     = "private"
  description = "Canned ACL to apply to the S3 bucket."
}


variable "enable_server_side_encryption" {
  type        = bool
  default     = false
  description = "Enable enable_server_side_encryption"
}

variable "sse_algorithm" {
  type        = string
  default     = "AES256"
  description = "The server-side encryption algorithm to use. Valid values are AES256 and aws:kms."
}

variable "enable_kms" {
  type        = bool
  default     = false
  description = "Enable enable_server_side_encryption"
}

variable "kms_master_key_id" {
  type        = string
  default     = ""
  description = "The AWS KMS master key ID used for the SSE-KMS encryption. This can only be used when you set the value of sse_algorithm as aws:kms. The default aws/s3 AWS KMS master key is used if this element is absent while the sse_algorithm is aws:kms."
}



# Module      : S3 BUCKET POLICY
# Description : Terraform S3 Bucket Policy module variables.
variable "aws_iam_policy_document" {
  type        = string
  default     = ""
  sensitive   = true
  description = "Specifies the number of days after object creation when the object expires."
}

variable "bucket_policy" {
  type        = bool
  default     = false
  description = "Conditionally create S3 bucket policy."
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
}

variable "bucket_prefix" {
  type        = string
  default     = null
  description = " (Optional, Forces new resource) Creates a unique bucket name beginning with the specified prefix."
}

variable "grants" {
  type = list(object({
    id          = string
    type        = string
    permissions = list(string)
    uri         = string
  }))
  default     = []
  description = "ACL Policy grant.conflict with acl.set acl null to use this"
}

variable "acl_grants" {
  type = list(object({
    id         = string
    type       = string
    permission = string
    uri        = string
  }))
  default = null

  description = "A list of policy grants for the bucket. Conflicts with `acl`. Set `acl` to `null` to use this."
}

variable "owner_id" {
  type        = string
  default     = ""
  description = "The canonical user ID associated with the AWS account."
}





variable "logging" {
  type        = bool
  default     = true
  description = "Logging Object to enable and disable logging"
}

variable "target_bucket" {
  type        = string
  default     = ""
  description = "The bucket where you want Amazon S3 to store server access logs."
}

variable "target_prefix" {
  type        = string
  default     = "log/"
  description = "A prefix for all log object keys."
}



variable "object_lock_configuration" {
  type = object({
    mode  = string #Valid values are GOVERNANCE and COMPLIANCE.
    days  = number
    years = number
  })
  default     = null
  description = "With S3 Object Lock, you can store objects using a write-once-read-many (WORM) model. Object Lock can help prevent objects from being deleted or overwritten for a fixed amount of time or indefinitely."

}


variable "create_bucket" {
  type        = bool
  default     = true
  description = "Conditionally create S3 bucket."
}



variable "attach_require_latest_tls_policy" {
  description = "Controls if S3 bucket should require the latest version of TLS"
  type        = bool
  default     = false
}

variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket."
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
  type        = bool
  default     = true
}

variable "attach_policy" {
  description = "Controls if S3 bucket should have bucket policy attached (set to `true` to use value of `policy` as bucket policy)"
  type        = bool
  default     = false
}
