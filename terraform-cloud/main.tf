#module "namespaces" {
#  source            = "./modules/namespace"
#  for_each          = var.namespaces
#  namespace         = each.key
#  description       = each.value.description
#  admin_group_name  = lookup(each.value, "admin_group_name")
#  quota_rate_limit  = lookup(each.value, "quota_rate_limit")
#  quota_lease_count = lookup(each.value, "quota_lease_count")
#}

resource "vault_quota_rate_limit" "global" {
  name     = "global"
  path     = ""
  interval = 30
  rate     = 10000
}

module "app1" {
  source            = "./modules/namespace"
  namespace         = "app1"
  description       = "app1 namespace"
  admin_group_name  = "vault-app1-admin"
  quota_lease_count = 101
  quota_rate_limit  = 102
}

module "app2" {
  source            = "./modules/namespace"
  namespace         = "app2"
  description       = "app2 namespace"
  admin_group_name  = "vault-app2-admin"
  quota_lease_count = 201
  quota_rate_limit  = 202
}
