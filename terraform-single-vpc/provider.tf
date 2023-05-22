terraform {
    required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
   cloud {
    organization = "40net-cloud"

    workspaces {
      name = "fortigatecnf-single-vpc"
    }
  }
}
provider "aws"  {
  region = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
