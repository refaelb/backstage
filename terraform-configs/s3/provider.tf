provider "aws" {
  profile = var.PROFILE
  region = "us-east-1"
}

# provider "aws" {
#   alias = "us-east-1"
#   region = "us-east-1"
# }