terraform {
  required_version = ">=1.12.0"
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 4.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.0"
    }
  }
}
