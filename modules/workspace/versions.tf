terraform {
  required_version = ">= 1.14.0"
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.73"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.6"
    }
  }
}
