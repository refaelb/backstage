
# variable "region" {
#     description = "region"
#     default = us-east-1
# }
variable "ami_id" {
    description = "ami_id"
    default = ami-032346ab877c418af
    }
variable "instance_type" {
    description = "type"
    default = t3-micro
}

variable "security_group_id" {}