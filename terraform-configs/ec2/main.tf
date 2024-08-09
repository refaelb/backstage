

resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [var.security_group_id]
}

variable "region" {}
variable "ami_id" {}
variable "instance_type" {}
variable "security_group_id" {}
