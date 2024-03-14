variable "namespaces" {
  type = map(object({
    description       = string
    quota_lease_count = optional(number)
    quota_rate_limit  = optional(number)
  }))
  default = {}
}