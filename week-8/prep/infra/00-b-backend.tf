# https://www.terraform.io/language/settings/backends/gcs
terraform {
  backend "gcs" {
    bucket = "aaron-mcdonald-state-bucket"
    prefix = "terraform/050126"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }

    # tls = {
    #   source  = "hashicorp/tls"
    #   version = "~> 4.0"
    # }
  }
}

