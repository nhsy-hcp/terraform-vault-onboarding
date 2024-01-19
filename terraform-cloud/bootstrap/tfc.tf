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

resource "tfe_workspace" "default" {
  name         = var.tfc_workspace
  organization = var.tfc_organization

  auto_apply          = false
  description         = "Terraform Cloud and Vault onboarding demo"
  project_id          = data.tfe_project.default.id
  speculative_enabled = true
  tag_names = [
    "demo",
    "vault"
  ]
  terraform_version = "1.7.0"
  trigger_patterns  = ["terraform-cloud/**"]

  vcs_repo {
    branch     = "main"
    identifier = format("%s/%s", var.github_organization, var.github_repository)
    #      oauth_token_id = tfe_oauth_client.default.oauth_token_id
    oauth_token_id = data.tfe_oauth_client.default.oauth_token_id
  }
  working_directory = "terraform-cloud"
}

resource "tfe_variable_set" "default" {
  name         = "Vault dynamic credentials"
  description  = "JWT Vault"
  organization = var.tfc_organization
}

resource "tfe_workspace_variable_set" "default" {
  workspace_id    = tfe_workspace.default.id
  variable_set_id = tfe_variable_set.default.id
}

resource "tfe_variable" "enable_vault_provider_auth" {
  key             = "TFC_VAULT_PROVIDER_AUTH"
  value           = "true"
  category        = "env"
  variable_set_id = tfe_variable_set.default.id
}

resource "tfe_variable" "vault_address" {
  key             = "TFC_VAULT_ADDR"
  value           = var.vault_address
  category        = "env"
  variable_set_id = tfe_variable_set.default.id
}

resource "tfe_variable" "tfc_vault_run_role" {
  key             = "TFC_VAULT_RUN_ROLE"
  value           = var.vault_role
  category        = "env"
  variable_set_id = tfe_variable_set.default.id
}

resource "tfe_variable" "tfc_vault_namespace" {
  key             = "TFC_VAULT_NAMESPACE"
  value           = var.vault_namespace
  category        = "env"
  variable_set_id = tfe_variable_set.default.id
}

resource "tfe_variable" "tfc_vault_auth_path" {
  key             = "TFC_VAULT_AUTH_PATH"
  value           = var.vault_auth_path
  category        = "env"
  variable_set_id = tfe_variable_set.default.id
}
