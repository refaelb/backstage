module "vote_service_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = var.name
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = var.vpc_id

  ingress_cidr_blocks      = ["10.10.0.0/16"]
  ingress_rules            = ["https-443-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8090
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "10.10.0.0/16"
    },
    {
      rule        = "postgresql-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}


# RDS Module
module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = var.name

  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.t3.micro"
  allocated_storage = 5

  db_name  = "demodb"
  username = "user"
  port     = "3306"

  iam_database_authentication_enabled = true

  vpc_security_group_ids = [module.vote_service_sg.security_group_id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval    = "30"
  monitoring_role_name   = "MyRDSMonitoringRole"
  create_monitoring_role = true

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = var.db_subnets_ids

  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"

  # Database Deletion Protection
  deletion_protection = true

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
  count = var.create_rds ? 1 : 0
}



# locals {
#   combined_ingress_rules = concat(
#     var.ingress_rules,
#     var.create_ec2 ? [
#       {
#         port        = 3306
#         cidr_blocks = var.create_ec2 ? [module.user_service_sg[0].security_group_id] : [] # Wrap the ID in a list
#       }
#     ] : []
#   )
# }



# module "user_service_sg" {
#   source = "../modules/sg"
#   providers = {
#     aws = aws
#   }
#   vpc_id = var.vpc_id
#   name        = var.name
#   description = "Security group for user-service with custom ports open within VPC"

#   ingress_rules = local.combined_ingress_rules

#   count = var.create_ec2 ? 1 : 0
# }






# EC2 Instance Module
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = var.name

  instance_type          = "t2.micro"
  key_name               = var.name
  monitoring             = true
  vpc_security_group_ids = [module.vote_service_sg.security_group_id]
  # vpc_security_group_ids = var.create_ec2 ? [module.user_service_sg[0].security_group_id] : [] # Wrap the ID in a list
  subnet_id              = var.subnet_id

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
  count = var.create_ec2 ? 1 : 0
}

