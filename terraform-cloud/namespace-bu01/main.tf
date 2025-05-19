resource "vault_identity_group" "dev12345" {
  name = "dev12345-group"
  type = "internal"
}

module "kv_engine" {
  source      = "../modules/kv-engine"
  path        = "secrets/"
  description = "KV v2 secrets"
}
