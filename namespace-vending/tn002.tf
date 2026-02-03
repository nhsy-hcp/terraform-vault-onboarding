module "tn002_namespace" {
  source                     = "../modules/namespace"
  namespace                  = "tn002"
  description                = "tn002 namespace"
  admin_group_name           = "vault-tn002-admin"
  additional_admin_group_ids = [data.vault_identity_group.global_admin.group_id]
}

module "tn002_workspace" {
  source = "../modules/workspace"

  enable_tfc_agent_pool = var.enable_tfc_agent_pool
  github_organization   = var.github_organization
  github_repository     = var.github_repository
  okta_api_token        = var.okta_api_token
  okta_org_name         = var.okta_org_name
  okta_base_url         = var.okta_base_url
  tfc_organization      = var.tfc_organization
  tfc_project           = var.tfc_project
  tfc_workspace         = "${var.tfc_workspace_prefix}-namespace-${module.tn002_namespace.namespace}"
  tfc_working_directory = "${var.tfc_working_directory_prefix}/namespace-${module.tn002_namespace.namespace}"
  tfc_variables         = {}
  vault_address         = var.vault_address
  vault_auth_path       = var.vault_auth_path
  vault_auth_role       = var.vault_auth_role
  vault_namespace       = module.tn002_namespace.namespace
  tfc_vault_namespace   = var.vault_namespace != null ? "${var.vault_namespace}/${module.tn002_namespace.namespace}" : module.tn002_namespace.namespace

  depends_on = [module.tn002_namespace]
}
