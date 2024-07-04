resource "aws_s3_bucket" "private_bucket" {
  bucket = "test"
  acl    = "private"
}
