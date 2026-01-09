terraform {
  cloud {
    organization = "nhsy-hcp-org"
    workspaces {
      name    = "terraform-vault-onboarding-namespace-root"
      project = "vault-onboarding"
    }
  }
}
