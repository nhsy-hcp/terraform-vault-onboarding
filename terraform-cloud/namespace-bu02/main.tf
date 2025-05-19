module "kv_engine" {
  source      = "../modules/kv-engine"
  path        = "secrets/"
  description = "KV v2 secrets"
}
