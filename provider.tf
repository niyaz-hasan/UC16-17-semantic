#terraform {
#  backend "s3" {
#    bucket = "terraform-remote-st"
#    key    = "semantic/terraform.tfstate"
#    region = "us-east-1" 
# 
#    # For State Locking
#    #dynamodb_table = "terraform-locks"    
#  } 
#  } 
# Terraform Block
terraform {
  #required_version = ">= 1.0" # which means any version equal & above 0.14 like 0.15, 0.16 etc and < 1.xx
  required_version = ">= 1.6.0"   
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.31"
    }
  }
}

# Provider Block
provider "aws" {
  region  = var.aws_region
}