# module "tfe_workspace" {
#   source                = "./../tfe-workspace"
#   enable_tfc_agent_pool = var.enable_tfc_agent_pool
#   github_organization   = var.github_organization
#   github_repository     = var.github_repository
#   okta_api_token        = var.okta_api_token
#   okta_org_name         = var.okta_org_name
#   okta_base_url         = var.okta_base_url
#   tfc_organization      = var.tfc_organization
#   tfc_project           = var.tfc_project
#   tfc_workspace         = var.tfc_workspace
#   tfc_working_directory = var.tfc_working_directory
#   vault_address         = var.vault_address
#   vault_auth_path       = var.vault_auth_path
#   vault_auth_role       = var.vault_auth_role
#   vault_policy          = var.vault_policy
# }