terraform {
  required_version = ">=1.12.0"
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 6.5"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.6"
    }
  }
}
