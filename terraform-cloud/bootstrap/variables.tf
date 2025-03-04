variable "github_organization" {
  type        = string
  description = "Name of the GitHub organization."
}

variable "github_repository" {
  type        = string
  description = "Name of the GitHub repository."
  default     = "terraform-vault-onboarding"
}

variable "tfc_organization" {
  type        = string
  description = "Name of the TFC organization."
}

variable "tfc_project" {
  type        = string
  description = "Name of the TFC project."
  default     = "default project"
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

variable "tfc_token" {
  type        = string
  description = "Terraform Cloud API token"
}

variable "default_lease_ttl" {
  type        = string
  description = "Default lease TTL for Vault tokens"
  default     = "10m"
}

variable "max_lease_ttl" {
  type        = string
  description = "Maximum lease TTL for Vault tokens"
  default     = "30m"
}

variable "token_type" {
  type        = string
  description = "Token type for Vault tokens"
  default     = "default-service"
}

variable "vault_auth_path" {
  type        = string
  description = "Mount path where JWT Auth will be configured"
  default     = "jwt/tfc"
}

variable "vault_address" {
  type        = string
  description = "Vault API endpoint"
}

variable "vault_address_tfc_agent" {
  type        = string
  description = "Vault API endpoint for TFC agent"
}

variable "vault_auth_role_prefix" {
  type        = string
  description = "Vault role name"
  default     = "tfc-admin"
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

variable "okta_auth_path" {
  type    = string
  default = "oidc"
}

variable "okta_users" {
  type = map(object({
    first_name = string
    last_name  = string
    password   = string
    groups     = list(string)
  }))
  default = {}
}

variable "okta_api_token" {
  type        = string
  sensitive   = true
  description = "Okta API token"
}

variable "okta_mgmt_groups" {
  type = list(string)
  default = [
    "vault-admin",
    "vault-user"
  ]
}

variable "okta_namespace_groups" {
  type    = list(string)
  default = []
}

variable "enable_tfc_agent_pool" {
  type    = bool
  default = true
}
