terraform {
  required_version = ">=1.14.0"
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 6.5"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.73"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.6"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.111"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.8"
    }
  }
}
