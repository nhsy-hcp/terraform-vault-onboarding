terraform {
  cloud {
    organization = "nhsy-hcp-org"
    workspaces {
      name    = "terraform-vault-onboarding-baseline-configuration"
      project = "demo"
    }
  }
}