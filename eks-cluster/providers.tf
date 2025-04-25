terraform {
  backend "s3" {
    bucket         = "ltc-devops-project-tf-state"
    key            = "eks-cluster/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-eks-state-locking"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" 
    }
  }

  required_version = ">= 1.3"
}