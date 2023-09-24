provider "aws" {
  region = "us-east-2"
}

resource "aws_db_instance" "example" {
  identifier_prefix = "db-prod"
  engine = "mysql"
  allocated_storage = 10
  instance_class = "db.t2.micro"
  skip_final_snapshot = true
  db_name = "prod_database"

  username = var.db_username
  password = var.db_password
}

terraform {
  backend "s3" {
    bucket = "prem-terraform-state"
    key = "prod/data-store/mysql/terraform.tfstate"
    region = "us-east-2"

    dynamodb_table = "prem-terraform-locks"
    encrypt = true
  }
}