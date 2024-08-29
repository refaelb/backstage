create_rds = true
create_ec2 = true

name = "backstage"
subnet_id = "subnet-03c35ea8d4c7d6e16"
db_subnets_ids = ["subnet-06186e8a453ba359c ", "subnet-07841247272960352 "]
vpc_id = "vpc-044ea61c95511720f"
ingress_rules = [
    {
      port        = 8080
      cidr_blocks = ["10.10.0.0/16"]
    },
    {
      port        = 5432
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = 443
      cidr_blocks = ["10.10.0.0/16"]
    }
    
  ]