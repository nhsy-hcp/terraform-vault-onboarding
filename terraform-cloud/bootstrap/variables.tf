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

variable "tfc_workspace" {
  type        = string
  description = "Name of the TFC worksapce."
  default     = "terraform-vault-onboarding"
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
  default     = "jwt_tfc"
}

variable "vault_address" {
  type        = string
  description = "Vault HTTPS endpoint"
}

variable "vault_namespace" {
  type        = string
  description = "Vault namespace"
  default     = "admin"
}

variable "vault_role" {
  type        = string
  description = "Vault role name"
  default     = "tfc-admin"
}