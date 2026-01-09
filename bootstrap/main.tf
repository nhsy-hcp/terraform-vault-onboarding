module "namespace_root" {
  source                = "./modules/workspace"
  enable_tfc_agent_pool = var.enable_tfc_agent_pool
  github_organization   = var.github_organization
  github_repository     = var.github_repository
  okta_api_token        = var.okta_api_token
  okta_org_name         = var.okta_org_name
  okta_base_url         = var.okta_base_url
  tfc_organization      = var.tfc_organization
  tfc_project           = var.tfc_project
  tfc_workspace         = "${var.tfc_workspace_prefix}-namespace-root"
  tfc_working_directory = "${var.tfc_working_directory_prefix}/namespace-root"
  tfc_terraform_variables = {
    "okta_auth_path" = { value = var.okta_auth_path }
    "okta_base_url"  = { value = var.okta_base_url }
    "okta_org_name"  = { value = var.okta_org_name }
  }
  vault_address     = var.vault_address_tfc_agent
  vault_auth_path   = vault_jwt_auth_backend.tfc.path
  vault_auth_role   = "${var.vault_auth_role_prefix}-namespace-root"
  vault_policy_name = vault_policy.tfc_admin.name
}

module "namespace-vending" {
  source                = "./modules/workspace"
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
  tfc_token             = var.tfc_token
  tfc_terraform_variables = {
    "github_organization" = { value = var.github_organization }
    "github_repository"   = { value = var.github_repository }
    "okta_api_token"      = { value = var.okta_api_token, sensitive = true }
    "okta_org_name"       = { value = var.okta_org_name }
    "okta_base_url"       = { value = var.okta_base_url }
    "tfc_organization"    = { value = var.tfc_organization }
    "tfc_project"         = { value = var.tfc_project }
    "vault_address"       = { value = var.vault_address_tfc_agent }
    "vault_auth_path"     = { value = vault_jwt_auth_backend.tfc.path }
  }
  vault_address     = var.vault_address_tfc_agent
  vault_auth_path   = vault_jwt_auth_backend.tfc.path
  vault_auth_role   = "${var.vault_auth_role_prefix}-namespace-vending"
  vault_policy_name = vault_policy.tfc_admin.name
}
