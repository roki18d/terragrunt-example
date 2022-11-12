resource "aws_s3_bucket_acl" "this" {
  bucket = var.bucket_name
  acl    = var.canned_acl
}