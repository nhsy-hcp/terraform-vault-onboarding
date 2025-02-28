#resource "tfe_oauth_client" "default" {
#  name             = "GitHub-OAuth"
#  api_url          = "https://api.github.com"
#  http_url         = "https://github.com"
#  service_provider = "github"
#  organization     = var.tfc_organization_name
#  oauth_token      = var.github_oauth_token
#}

## Connect TFC org to Github OAuth Apps
## https://developer.hashicorp.com/terraform/cloud-docs/vcs/github
data "tfe_oauth_client" "default" {
  organization     = var.tfc_organization
  service_provider = "github"
  name             = "GitHub-OAuth"
}

data "tfe_project" "default" {
  name         = var.tfc_project
  organization = var.tfc_organization
}

data "tfe_agent_pool" "default" {
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
    "terraform-cloud/modules/**"
  ]

  vcs_repo {
    branch     = "main"
    identifier = format("%s/%s", var.github_organization, var.github_repository)
    #      oauth_token_id = tfe_oauth_client.default.oauth_token_id
    oauth_token_id = data.tfe_oauth_client.default.oauth_token_id
  }
  working_directory = var.tfc_working_directory
}

resource "tfe_variable" "enable_vault_provider_auth" {
  key             = "TFC_VAULT_PROVIDER_AUTH"
  value           = "true"
  category        = "env"
  workspace_id    = tfe_workspace.default.id
}

resource "tfe_variable" "tfc_vault_address" {
  key             = "TFC_VAULT_ADDR"
  value           = var.vault_address_tfc_agent
  category        = "env"
  workspace_id    = tfe_workspace.default.id
}

resource "tfe_variable" "tfc_vault_run_role" {
  key             = "TFC_VAULT_RUN_ROLE"
  value           = var.vault_auth_role
  category        = "env"
  workspace_id    = tfe_workspace.default.id
}

resource "tfe_variable" "tfc_vault_auth_path" {
  key             = "TFC_VAULT_AUTH_PATH"
  value           = var.vault_auth_path
  category        = "env"
  workspace_id    = tfe_workspace.default.id
}

resource "tfe_variable" "okta_api_token" {
  key          = "OKTA_API_TOKEN"
  value        = var.okta_api_token
  category     = "env"
  sensitive    = true
  workspace_id    = tfe_workspace.default.id
}

resource "tfe_variable" "okta_org_name" {
  key          = "okta_org_name"
  value        = var.okta_org_name
  category     = "terraform"
  workspace_id    = tfe_workspace.default.id
}

resource "tfe_variable" "tfc_organization" {
  key          = "tfc_organization"
  value        = var.tfc_project
  category     = "terraform"
  workspace_id    = tfe_workspace.default.id
}

resource "tfe_variable" "tfc_project" {
  key          = "tfc_project"
  value        = var.tfc_project
  category     = "terraform"
  workspace_id    = tfe_workspace.default.id
}

# resource "tfe_variable" "vault_auth_path" {
#   key          = "vault_auth_path"
#   value        = var.vault_auth_path
#   category     = "terraform"
#   workspace_id    = tfe_workspace.default.id
# }

resource "tfe_workspace_settings" "agent_pool" {
  count          = var.enable_tfc_agent_pool ? 1 : 0
  workspace_id   = tfe_workspace.default.id
  agent_pool_id  = data.tfe_agent_pool.default.id
  execution_mode = "agent"
}
