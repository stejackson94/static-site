terraform {
  required_version = ">= 1.12.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
      configuration_aliases = [ aws.virginia ]
    }
  }

  backend "s3" {
    bucket = "personalwebsitestate"
    key    = "state/terraform.tfstate"
    region = "eu-west-2"
  }
}


# Configure the AWS Provider
provider "aws" {
  region = "eu-west-2"
}

#ACM needs to be issued in us-east-1
provider "aws" {
  region = "us-east-1"
  alias = "virginia"
}

