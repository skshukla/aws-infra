terraform {
  required_providers {
    aws = {
      version = "= 4.48.0"
    }
  }
}


# Brainboard aliases for AWS regions
provider "aws" {
  alias  = "ap-southeast-1"
  region = "ap-southeast-1"
}
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}
