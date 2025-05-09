terraform {
  backend "s3" {
    bucket         = "ltc-devops-project-tf-state"
    key            = "eks-cluster-backend/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-eks-state-locking"
    encrypt        = true
  }

  #############################################################
  ## Add the above code to the backend block to switch from local backend to remote AWS backend
  ## Before that run just the code below to create the S3 bucket and DynamoDB table 
  ## To store the state file and lock it
  #############################################################

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket        = "ltc-devops-project-tf-state"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "terraform_bucket_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_crypto_conf" {
  bucket        = aws_s3_bucket.terraform_state.bucket 
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-eks-state-locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
### The S3 is used to store the state file and the DynamoDB table is used for locking the state file.