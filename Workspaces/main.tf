provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "example" {
  ami = "ami-024e6efaf93d85776"
  instance_type = terraform.workspace == "default" ? "t2.medium" : "t2.micro"
}

terraform {
  backend "s3" {
    bucket = "prem-terraform-state"
    key = "workspace-example/terraform.tfstate"
    region = "us-east-2"

    dynamodb_table = "prem-terraform-locks"
    encrypt = true
  }
}




