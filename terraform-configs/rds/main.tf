
resource "aws_db_instance" "example" {
  allocated_storage    = 20
  engine               = "mysql"
  instance_class       = "db.t2.micro"
  name                 = var.db_name
  username             = var.username
  password             = var.password
  vpc_security_group_ids = [var.security_group_id]
  skip_final_snapshot  = true
}

variable "region" {}
variable "db_name" {}
variable "username" {}
variable "password" {}
variable "security_group_id" {}
