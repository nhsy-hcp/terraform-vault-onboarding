data "vault_policy_document" "bu01_team_reader" {
  for_each = toset(["team1", "team2"])
  rule {
    path         = "secrets/data/${each.value}/*"
    capabilities = ["read", "list"]
  }
  rule {
    path         = "secrets/metadata/${each.value}/*"
    capabilities = ["read", "list"]
  }
  rule {
    path         = "secrets/metadata/"
    capabilities = ["list"]
  }
  rule {
    path         = "sys/mounts"
    capabilities = ["read"]
  }
}

module "bu01_namespace" {
  source            = "./../modules/namespace"
  namespace         = "bu01"
  description       = "bu01 namespace"
  admin_group_name  = "vault-bu01-admin"
  quota_lease_count = 101
  quota_rate_limit  = 102
  rbac_delegation = {
    "bu01-team1-reader" = {
      group_name = "vault-bu01-team1-reader"
      policy     = data.vault_policy_document.bu01_team_reader["team1"].hcl
    },
    "bu01-team2-reader" = {
      group_name = "vault-bu01-team2-reader"
      policy     = data.vault_policy_document.bu01_team_reader["team2"].hcl
    }
  }
}

module "bu01_workspace" {
  source = "./../modules/workspace"

  enable_tfc_agent_pool = var.enable_tfc_agent_pool
  github_organization   = var.github_organization
  github_repository     = var.github_repository
  okta_api_token        = var.okta_api_token
  okta_org_name         = var.okta_org_name
  okta_base_url         = var.okta_base_url
  tfc_organization      = var.tfc_organization
  tfc_project           = var.tfc_project
  tfc_workspace         = "${var.tfc_workspace_prefix}-namespace-bu01"
  tfc_working_directory = "${var.tfc_working_directory_prefix}/namespace-bu01"
  tfc_terraform_variables = {
    "okta_org_name" = { value = var.okta_org_name }
    "okta_base_url" = { value = var.okta_base_url }
  }
  vault_address   = var.vault_address
  vault_auth_path = var.vault_auth_path
  vault_auth_role = var.vault_auth_role
  vault_namespace = module.bu01_namespace.namespace

  depends_on = [module.bu01_namespace]
}
