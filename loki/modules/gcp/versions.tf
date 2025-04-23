terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.27"
    }
  }
  required_version = ">= 1.5, < 2.0"
}
