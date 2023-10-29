provider "aws" {
  region = "us-east-2"
}

module "webserver_cluster" {
  source = "/Users/premkumarmanoharan/Documents/Projects/Terraform/Terraform-Modules/services/webserver-cluster"
  cluster_name = "webservers-prod"
  db_remote_address = data.terraform_remote_state.db.outputs.address
  db_remote_port = data.terraform_remote_state.db.outputs.port
  ami = "ami-024e6efaf93d85776"
  server_text = "This is Production environment"
  instance_type = "t2.medium"
  min_size = 2
  max_size = 10
  enable_autoscaling = true
  custom_tags = {
    Owner = "team-prem"
    ManagedBy = "terraform"
  }
}



data "terraform_remote_state" "db" {
  backend = "s3"
  config = {
    bucket = "prem-terraform-state"
    key = "prod/data-store/mysql/terraform.tfstate"
    region = "us-east-2"
  }
}

terraform {
  backend "s3" {
    bucket = "prem-terraform-state"
    key = "prod/services/webserver-cluster/terraform.tfstate"
    region = "us-east-2"

    dynamodb_table = "prem-terraform-locks"
    encrypt = true
  }
}

