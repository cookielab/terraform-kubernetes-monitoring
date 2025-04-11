terraform {
  backend "local" {}
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.27.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.11.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.94.1"
    }
  }
  required_version = ">= 0.14"
}
