terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.60.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
  }
}

provider "aws" {
  region = "ap-south-1"

  access_key = "AKIFPNG"
  secret_key = "U45gVjMsWPxO9o9PauPxgd"
}
