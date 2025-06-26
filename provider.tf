terraform {
  backend "s3" {
    bucket = "terraform-remote-st"
    key    = "semantic/terraform.tfstate"
    region = "us-east-1" 
 
    # For State Locking
    #dynamodb_table = "terraform-locks"    
  } 
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