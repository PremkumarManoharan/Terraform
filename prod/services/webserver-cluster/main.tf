provider "aws" {
  region = "us-east-2"
}

module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"
  cluster_name = "webservers-prod"
  db_remote_address = data.terraform_remote_state.db.outputs.address
  db_remote_port = data.terraform_remote_state.db.outputs.port
  instance_type = "t2.medium"
  min_size = 2
  max_size = 10
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  scheduled_action_name = "scale_out_during_business_hours"
  min_size = 2
  max_size = 10
  desired_capacity = 10
  recurrence = "0 9 * * *"

  autoscaling_group_name = module.webserver_cluster.asg_name
}

resource "aws_autoscaling_schedule" "scale_in_at_off_business_hours" {
  scheduled_action_name = "scale_in_at_off_business_hours"
  min_size = 2
  max_size = 10
  desired_capacity = 2
  recurrence = "0 17 * * *"

  autoscaling_group_name = module.webserver_cluster.asg_name
  
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

