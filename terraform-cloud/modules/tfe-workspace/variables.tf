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

# variable "default_lease_ttl" {
#   type        = string
#   description = "Default lease TTL for Vault tokens"
#   default     = "10m"
# }
#
# variable "max_lease_ttl" {
#   type        = string
#   description = "Maximum lease TTL for Vault tokens"
#   default     = "30m"
# }

variable "token_type" {
  type        = string
  description = "Token type for Vault tokens"
  default     = "default-service"
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

variable "vault_policy" {
  type        = string
  description = "Vault policy name"
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

variable "okta_api_token" {
  type        = string
  sensitive    = true
  description = "Okta API token"
  default     = null
}

variable "enable_tfc_agent_pool" {
  type    = bool
  default = true
}

variable "terraform_version" {
  type        = string
  description = "Version of Terraform to use"
  default     = "~> 1.10.0"
}

variable "tfc_terraform_variables" {
  type        = map(object({
    value     = string
    sensitive = optional(bool, false)
  }))
  description = "Map of additional Terraform variables"
  default     = {}
}

variable "tfc_token" {
  type        = string
  description = "TFC API token"
  default     = null
}