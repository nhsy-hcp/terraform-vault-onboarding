#module "namespaces" {
#  source            = "./modules/namespace"
#  for_each          = var.namespaces
#  namespace         = each.key
#  description       = each.value.description
#  admin_group_name  = lookup(each.value, "admin_group_name")
#  quota_rate_limit  = lookup(each.value, "quota_rate_limit")
#  quota_lease_count = lookup(each.value, "quota_lease_count")
#}

module "dev" {
  source            = "../modules/namespace"
  namespace         = "dev"
  description       = "dev namespace"
  admin_group_name  = "vault-dev-admin"
  quota_lease_count = 101
  quota_rate_limit  = 102
}

module "tst" {
  source            = "../modules/namespace"
  namespace         = "tst"
  description       = "tst namespace"
  admin_group_name  = "vault-tst-admin"
  quota_lease_count = 201
  quota_rate_limit  = 202
}

