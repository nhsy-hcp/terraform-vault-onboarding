variable "namespace" {
  type = string
}

variable "description" {
  type = string
}

variable "admin_group_name" {
  type = string
}

variable "enable_quotas" {
  type        = bool
  description = "Enable Vault quota resources for the namespace"
  default     = false
}

variable "quota_lease_count" {
  type    = number
  default = 100
}

variable "quota_rate_limit" {
  type    = number
  default = 100
}

variable "okta_auth_path" {
  type    = string
  default = "oidc"
}

variable "rbac_delegation" {
  type = map(object({
    group_name = string,
    policies   = map(string),
  }))
  default = {}
}
