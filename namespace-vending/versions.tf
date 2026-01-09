terraform {
  required_version = ">=1.12.0"
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 6.5"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.72"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.6"
    }
  }
}
