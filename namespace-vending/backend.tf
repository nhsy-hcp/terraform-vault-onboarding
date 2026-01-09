terraform {
  cloud {
    organization = "nhsy-hcp-org"
    workspaces {
      name    = "terraform-vault-onboarding-namespace-vending"
      project = "vault-onboarding"
    }
  }
}
