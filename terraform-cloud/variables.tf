variable "namespaces" {
  type = map(object({
    description       = string
    admin_group_name  = string
    quota_lease_count = optional(number)
    quota_rate_limit  = optional(number)
  }))
  default = {}
}

variable "okta_org_url" {
  type        = string
  description = "Okta organization URL"
}