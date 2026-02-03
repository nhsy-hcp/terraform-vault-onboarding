module "kv_engine" {
  source      = "../modules/kv-engine"
  path        = "shared/"
  description = "KV v2 secrets"
}
