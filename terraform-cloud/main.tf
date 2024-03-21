module "namespaces" {
  source            = "./modules/namespace"
  for_each          = var.namespaces
  namespace         = each.key
  description       = each.value.description
  admin_group_name  = lookup(each.value, "admin_group_name")
  quota_rate_limit  = lookup(each.value, "quota_rate_limit")
  quota_lease_count = lookup(each.value, "quota_lease_count")
}

#module "app1" {
#  source            = "./modules/namespace"
#  namespace         = "app1"
#  description       = "app1 namespace"
#  admin_group_id    = "vault-app1-admin"
#  quota_lease_count = 101
#  quota_rate_limit  = 102
#}

resource "vault_quota_rate_limit" "global" {
  name     = "global"
  path     = ""
  interval = 30
  rate     = 10000
}
