namespaces = {
  app1 = {
    description       = "app1 namespace"
    quota_lease_count = 101
    quota_rate_limit  = 102
  },
  app2 = {
    description       = "app2 namespace"
    quota_lease_count = 201
    quota_rate_limit  = 202

  },
  app3 = {
    description       = "app3 namespace"
    quota_lease_count = 301
    quota_rate_limit  = 302

  }
}


quota_lease_count = optional(number)
quota_rate_limit  = optional(number)