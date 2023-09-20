provider "aws" {
  region = "us-east-2"
}
//s3 Bucket creation with delete lock lifecycle
resource "aws_s3_bucket" "terraform_state" {
  bucket = "prem-terraform-state"
  lifecycle {
    prevent_destroy = true
  }
}

//versioning for s3 bucket create above
resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

//enabling server side encryption for s3 bucket created above
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

//diabling public access to the s3 bucket created above
resource "aws_s3_bucket_public_access_block" "public_access" {
    bucket = aws_s3_bucket.terraform_state.id
    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

//create dynamodb for lock feature in state file of terraform
resource "aws_dynamodb_table" "terraform_locks" {
    name = "prem-terraform-locks"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
      name = "LockID"
      type = "S"
    }
}

//connect to remote backend which is s3 for versioning and locking feature
terraform {
  backend "s3" {
    bucket = "prem-terraform-state"
    key = "global/s3/terraform.tfstate"
    region = "us-east-2"

    dynamodb_table = "prem-terraform-locks"
    encrypt = true
  }
}

