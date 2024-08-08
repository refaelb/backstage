
resource "aws_s3_bucket" "example" {
  bucket = "backstage-test"

  tags = {
    Name        = "backstage"
    Environment = "Dev"
  }
}