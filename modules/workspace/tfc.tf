data "tfe_github_app_installation" "default" {
  name = var.github_organization
}

data "tfe_project" "default" {
  name         = var.tfc_project
  organization = var.tfc_organization
}

data "tfe_agent_pool" "default" {
  count        = var.enable_tfc_agent_pool ? 1 : 0
  organization = var.tfc_organization
  name         = "localhost"
}
resource "tfe_workspace" "default" {
  name         = var.tfc_workspace
  organization = var.tfc_organization

  auto_apply          = true
  description         = "Terraform Cloud and Vault onboarding demo"
  project_id          = data.tfe_project.default.id
  speculative_enabled = true
  tag_names = [
    "demo",
    "vault"
  ]
  terraform_version = var.terraform_version

  trigger_patterns = [
    "${var.tfc_working_directory}/**",
    "modules/**/*",
    "policies/**"
  ]

  vcs_repo {
    branch                     = "main"
    identifier                 = format("%s/%s", var.github_organization, var.github_repository)
    github_app_installation_id = data.tfe_github_app_installation.default.id
  }
  working_directory = var.tfc_working_directory
}

resource "tfe_variable" "enable_vault_provider_auth" {
  key          = "TFC_VAULT_PROVIDER_AUTH"
  value        = "true"
  category     = "env"
  workspace_id = tfe_workspace.default.id
}

resource "tfe_variable" "tfc_vault_address" {
  key          = "TFC_VAULT_ADDR"
  value        = var.vault_address
  category     = "env"
  workspace_id = tfe_workspace.default.id
}

resource "tfe_variable" "tfc_vault_namespace" {
  count        = var.vault_namespace != null ? 1 : 0
  key          = "TFC_VAULT_NAMESPACE"
  value        = var.vault_namespace
  category     = "env"
  workspace_id = tfe_workspace.default.id
}

resource "tfe_variable" "tfc_vault_run_role" {
  key          = "TFC_VAULT_RUN_ROLE"
  value        = var.vault_auth_role
  category     = "env"
  workspace_id = tfe_workspace.default.id
}

resource "tfe_variable" "tfc_vault_auth_path" {
  key          = "TFC_VAULT_AUTH_PATH"
  value        = var.vault_auth_path
  category     = "env"
  workspace_id = tfe_workspace.default.id
}

resource "tfe_variable" "tfe_token" {
  count        = var.tfc_token != null ? 1 : 0
  key          = "TFE_TOKEN"
  value        = var.tfc_token
  category     = "env"
  sensitive    = true
  workspace_id = tfe_workspace.default.id
}

resource "tfe_variable" "okta_api_token" {
  count        = var.okta_api_token != null ? 1 : 0
  key          = "OKTA_API_TOKEN"
  value        = var.okta_api_token
  category     = "env"
  sensitive    = true
  workspace_id = tfe_workspace.default.id
}

resource "tfe_variable" "okta_org_name" {
  count        = var.okta_org_name != null ? 1 : 0
  key          = "OKTA_ORG_NAME"
  value        = var.okta_org_name
  category     = "env"
  workspace_id = tfe_workspace.default.id
}

resource "tfe_variable" "okta_base_url" {
  count        = var.okta_base_url != null ? 1 : 0
  key          = "OKTA_BASE_URL"
  value        = var.okta_base_url
  category     = "env"
  workspace_id = tfe_workspace.default.id
}

resource "tfe_variable" "default" {
  for_each     = var.tfc_terraform_variables
  key          = each.key
  value        = each.value.value
  sensitive    = each.value.sensitive
  category     = "terraform"
  workspace_id = tfe_workspace.default.id
}

resource "tfe_workspace_settings" "agent_pool" {
  count          = var.enable_tfc_agent_pool ? 1 : 0
  workspace_id   = tfe_workspace.default.id
  agent_pool_id  = data.tfe_agent_pool.default[0].id
  execution_mode = "agent"
}
