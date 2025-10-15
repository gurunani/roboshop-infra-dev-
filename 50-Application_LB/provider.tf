terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.5.0"
    }
  }
   backend "s3" {
    bucket = "jd-aws-s3-bucket-demo"
    key    = "application-lb-key"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}