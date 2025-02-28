# variable "namespaces" {
#   type = map(object({
#     description       = string
#     admin_group_name  = string
#     quota_lease_count = optional(number)
#     quota_rate_limit  = optional(number)
#   }))
#   default = {}
# }

variable "okta_org_name" {
  type        = string
  description = "Okta organization name"
}

variable "okta_base_url" {
  type        = string
  description = "Okta base URL"
  default     = "okta.com"
}