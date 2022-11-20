provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket         = "cnl-tf-remote-states"
    key            = "environments/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}