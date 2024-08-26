# security-group-rules/main.tf


variable "ingress_rules" {
  type = list(object({
    port     = number
    cidr_blocks = list(string)
  }))
}

resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "ingress" {
  for_each = { for idx, rule in var.ingress_rules : idx => rule }

  type              = "ingress"
  from_port         = each.value.port
  to_port           = each.value.port
  protocol          = "tcp"
  cidr_blocks       = each.value.cidr_blocks
  security_group_id = aws_security_group.this.id
}
