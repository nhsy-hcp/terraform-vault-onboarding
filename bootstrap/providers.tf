provider "okta" {
  api_token = var.okta_api_token
  org_name  = var.okta_org_name
  base_url  = var.okta_base_url
}

provider "vault" {
  address   = hcp_vault_cluster.vault.vault_public_endpoint_url
  token     = hcp_vault_cluster_admin_token.vault.token
  namespace = "admin"
}

provider "hcp" {
  project_id = var.hcp_project_id
}
