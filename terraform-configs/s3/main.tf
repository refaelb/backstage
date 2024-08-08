resource "aws_s3_bucket" "private_bucket" {
  bucket = "backstage-test"
  acl    = "private"
}
