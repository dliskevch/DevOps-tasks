#----------------------------------------------------------
# My Terraform
#
# Global Variables in Remote State on S3
#----------------------------------------------------------
provider "aws" {
  region = "us-east-2"
}

terraform {
  backend "s3" {
    bucket = "dmytro-liskevych-terraform-state"
    key    = "globalvars/terraform.tfstate"
    region = "us-east-2"
  }
}

#==================================================

output "company_name" {
  value = "SoftServe"
}

output "owner" {
  value = "Dmytro_Liskevych"
}

output "tags" {
  value = {
    Project    = "Python-2021"
    CostCenter = "R&D"
    Country    = "Ukraine"
  }
}
