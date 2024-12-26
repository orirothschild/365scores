terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"

  assume_role {
    role_arn = "arn:aws:iam::492118544800:role/home-assignment-Access-Role"
  }
}
