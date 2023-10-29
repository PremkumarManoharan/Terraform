provider "aws" {
  region = "us-east-2"
}

module "webserver_cluster" {
  source = "/Users/premkumarmanoharan/Documents/Projects/Terraform/Terraform-Modules/services/webserver-cluster"
  cluster_name = "webservers-stage"
  db_remote_address = data.terraform_remote_state.db.outputs.address
  db_remote_port = data.terraform_remote_state.db.outputs.port
  instance_type = "t2.micro"
  min_size = 2
  max_size = 2
  ami = "ami-024e6efaf93d85776"
  server_text = "This is Staging environment"
  enable_autoscaling = false

  custom_tags = {
    Owner = "team-prem"
    ManagedBy = "terraform"
  }
}

data "terraform_remote_state" "db" {
  backend = "s3"
  config = {
    bucket = "prem-terraform-state"
    key = "stage/data-store/mysql/terraform.tfstate"
    region = "us-east-2"
  }
}

terraform {
  backend "s3" {
    bucket = "prem-terraform-state"
    key = "stage/services/webserver-cluster/terraform.tfstate"
    region = "us-east-2"

    dynamodb_table = "prem-terraform-locks"
    encrypt = true
  }
}

