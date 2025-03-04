module "baseline-configuration" {
  source                = "./../modules/tfe-workspace"
  enable_tfc_agent_pool = var.enable_tfc_agent_pool
  github_organization   = var.github_organization
  github_repository     = var.github_repository
  okta_api_token        = var.okta_api_token
  okta_org_name         = var.okta_org_name
  okta_base_url         = var.okta_base_url
  tfc_organization      = var.tfc_organization
  tfc_project           = var.tfc_project
  tfc_workspace         = "${var.tfc_workspace_prefix}-baseline-configuration"
  tfc_working_directory = "${var.tfc_working_directory_prefix}-baseline-configuration"
  vault_address         = var.vault_address_tfc_agent
  vault_auth_path       = vault_jwt_auth_backend.tfc.path
  vault_auth_role       = "${var.vault_auth_role}-baseline-configuration"
  vault_policy          = vault_policy.tfc_admin.name
}

module "namespace-vending" {
  source                = "./../modules/tfe-workspace"
  enable_tfc_agent_pool = var.enable_tfc_agent_pool
  github_organization   = var.github_organization
  github_repository     = var.github_repository
  okta_api_token        = var.okta_api_token
  okta_org_name         = var.okta_org_name
  okta_base_url         = var.okta_base_url
  tfc_organization      = var.tfc_organization
  tfc_project           = var.tfc_project
  tfc_workspace         = "${var.tfc_workspace_prefix}-namespace-vending"
  tfc_working_directory = "${var.tfc_working_directory_prefix}/namespace-vending"
  vault_address         = var.vault_address_tfc_agent
  vault_auth_path       = vault_jwt_auth_backend.tfc.path
  vault_auth_role       = "${var.vault_auth_role}-namespace-vending"
  vault_policy          = vault_policy.tfc_admin.name
}