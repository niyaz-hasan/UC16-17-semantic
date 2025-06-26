terraform {
  backend "s3" {
    bucket         = "dev-terraform-state-platform"
    key            = "usecase14/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile   = true
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.9.0"
}
provider "aws" {
  region = "us-east-1"
}