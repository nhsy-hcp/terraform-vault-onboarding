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

module "dev" {
  source            = "./modules/namespace"
  namespace         = "dev"
  description       = "dev namespace"
  admin_group_name  = "vault-dev-admin"
  quota_lease_count = 101
  quota_rate_limit  = 102
}

module "tst" {
  source            = "./modules/namespace"
  namespace         = "tst"
  description       = "tst namespace"
  admin_group_name  = "vault-tst-admin"
  quota_lease_count = 201
  quota_rate_limit  = 202
}

module "prd" {
  source            = "./modules/namespace"
  namespace         = "prd"
  description       = "prd namespace"
  admin_group_name  = "vault-prd-admin"
  quota_lease_count = 301
  quota_rate_limit  = 302
}