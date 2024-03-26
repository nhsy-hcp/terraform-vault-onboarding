namespaces = {
  app1 = {
    description       = "app1 namespace"
    admin_group_name  = "vault-app1-admin" #"00gendqnq81ZCXhGl5d7"
    quota_lease_count = 101
    quota_rate_limit  = 102
  },
  #  app2 = {
  #    description       = "app2 namespace"
  #    admin_group_name  = "vault-app2-admin" #"00gfuyug0hip0AktZ5d7"
  #    quota_lease_count = 201
  #    quota_rate_limit  = 202
  #
  #  },
  #  app3 = {
  #    description       = "app3 namespace"
  #    admin_group_id    = "vault-app3-admin" #"00gfuyug0ipO3w2Aw5d7"
  #    quota_lease_count = 301
  #    quota_rate_limit  = 302
  #
  #  }
}

okta_org_url = "https://dev-28540983.okta.com"