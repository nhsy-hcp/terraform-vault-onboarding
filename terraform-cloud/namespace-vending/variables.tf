variable "okta_api_token" {
  type        = string
  description = "Okta API token"
}

variable "okta_org_name" {
  type        = string
  description = "Okta organization name"
}

variable "okta_base_url" {
  type        = string
  description = "Okta base URL"
  default     = "okta.com"
}

variable "github_organization" {
  type        = string
  description = "Name of the GitHub organization."
}

variable "github_repository" {
  type        = string
  description = "Name of the GitHub repository."
}

variable "tfc_organization" {
  type        = string
  description = "Name of the TFC organization."
}

variable "tfc_project" {
  type        = string
  description = "Name of the TFC project."
}

variable "tfc_workspace_prefix" {
  type        = string
  description = "Name of the TFC workspace."
  default     = "terraform-vault-onboarding"
}

variable "tfc_working_directory_prefix" {
  type        = string
  description = "Working directory for the TFC workspace."
  default     = "terraform-cloud"
}

variable "vault_address" {
  type        = string
  description = "Vault API endpoint"
}

variable "vault_auth_path" {
  type        = string
  description = "Mount path where JWT Auth will be configured"
}

# variable "vault_auth_role" {
#   type        = string
#   description = "Vault role name"
# }

variable "vault_policy" {
  type        = string
  description = "Vault policy name"
}

variable "enable_tfc_agent_pool" {
  type    = bool
  default = true
}