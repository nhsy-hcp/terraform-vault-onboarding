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

variable "tfc_workspace" {
  type        = string
  description = "Name of the TFC workspace."
}

variable "tfc_working_directory" {
  type        = string
  description = "Working directory for the TFC workspace."
}

variable "token_ttl" {
  type        = string
  description = "Default lease TTL for Vault tokens"
  default     = 300 # 5 minutes
}

variable "token_max_ttl" {
  type        = string
  description = "Maximum lease TTL for Vault tokens"
  default     = 600 # 10 minutes
}

variable "token_type" {
  type        = string
  description = "Token type for Vault tokens"
  default     = "service"
}

variable "vault_auth_path" {
  type        = string
  description = "Mount path where JWT Auth will be configured"
}

variable "vault_address" {
  type        = string
  description = "Vault API endpoint"
}

variable "vault_auth_role" {
  type        = string
  description = "Vault role name"
}

variable "vault_namespace" {
  type        = string
  description = "Vault namespace where resources (JWT backend, roles) will be created. If null, uses the provider's default namespace."
  default     = null
}

variable "tfc_vault_namespace" {
  type        = string
  description = "Vault namespace to configure in TFC (TFC_VAULT_NAMESPACE). If null, defaults to vault_namespace."
  default     = null
}

variable "vault_auth_method" {
  type        = string
  description = "Vault auth method for TFC"
  default     = "jwt"
}

variable "vault_workload_identity_audience" {
  type        = string
  description = "Vault workload identity audience"
  default     = "vault.workload.identity"
}

variable "vault_policy_name" {
  type        = string
  description = "Vault policy name"
  default     = "tfc-namespace-admin"
}

variable "vault_token_type" {
  type        = string
  description = "Token type for Vault tokens"
  default     = "service"
}

variable "okta_api_token" {
  type        = string
  sensitive   = true
  description = "Okta API token"
  default     = null
}

variable "okta_org_name" {
  type        = string
  description = "Okta organization name"
  default     = null
}

variable "okta_base_url" {
  type        = string
  description = "Okta base URL"
  default     = "okta.com"
}

variable "enable_tfc_agent_pool" {
  type    = bool
  default = false
}

variable "terraform_version" {
  type        = string
  description = "Version of Terraform to use"
  default     = ">= 1.14.0"
}

variable "tfc_variables" {
  type = map(object({
    value     = string
    category  = optional(string, "terraform")
    sensitive = optional(bool, false)
  }))
  description = "Map of additional TFC variables"
  default     = {}
}

variable "tfc_token" {
  type        = string
  description = "TFC API token"
  default     = null
}

variable "vault_default_lease_ttl" {
  type        = string
  description = "Default lease TTL for Vault tokens"
  default     = "10m"
}

variable "vault_max_lease_ttl" {
  type        = string
  description = "Maximum lease TTL for Vault tokens"
  default     = "30m"
}
