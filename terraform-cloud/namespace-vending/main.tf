#module "namespaces" {
#  source            = "./modules/namespace"
#  for_each          = var.namespaces
#  namespace         = each.key
#  description       = each.value.description
#  admin_group_name  = lookup(each.value, "admin_group_name")
#  quota_rate_limit  = lookup(each.value, "quota_rate_limit")
#  quota_lease_count = lookup(each.value, "quota_lease_count")
#}

module "dev_namespace" {
  source            = "./../modules/namespace"
  namespace         = "dev"
  description       = "dev namespace"
  admin_group_name  = "vault-dev-admin"
  quota_lease_count = 101
  quota_rate_limit  = 102
}

module "dev_workspace" {
  source            = "./../modules/tfe-workspace"

  enable_tfc_agent_pool = var.enable_tfc_agent_pool
  github_organization   = var.github_organization
  github_repository     = var.github_repository
  okta_api_token        = var.okta_api_token
  okta_org_name         = var.okta_org_name
  okta_base_url         = var.okta_base_url
  tfc_organization      = var.tfc_organization
  tfc_project           = var.tfc_project
  tfc_workspace         = "${var.tfc_workspace_prefix}-namespace-dev"
  tfc_working_directory = "${var.tfc_working_directory_prefix}/namespace-dev"
    tfc_terraform_variables = {
      "okta_org_name" = { value = var.okta_org_name }
      "okta_base_url" = { value = var.okta_base_url }
    }
  vault_address         = var.vault_address
  vault_auth_path       = var.vault_auth_path
  vault_auth_role       = "tfc-admin-namespace-dev"
  vault_policy          = var.vault_policy
}



# module "tst" {
#   source            = "./../modules/namespace"
#   namespace         = "tst"
#   description       = "tst namespace"
#   admin_group_name  = "vault-tst-admin"
#   quota_lease_count = 201
#   quota_rate_limit  = 202
# }

