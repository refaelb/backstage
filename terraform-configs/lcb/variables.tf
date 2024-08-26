# variable "PROFILE" {
#     description = "profile name"
# }


variable "name" {
  type = string
}
variable "subnet_id" {
  type = string
}

variable "vpc_id" {
  type = string
}


variable "create_rds" {
  type    = bool
  default = false
}

variable "create_ec2" {
  type    = bool
  default = false
}

variable "ingress_rules" {
  type = list
  default = []
}