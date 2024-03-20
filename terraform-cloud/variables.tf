variable "namespaces" {
  type = map(object({
    description       = string
    admin_group_id    = string
    quota_lease_count = optional(number)
    quota_rate_limit  = optional(number)
  }))
  default = {}
}
