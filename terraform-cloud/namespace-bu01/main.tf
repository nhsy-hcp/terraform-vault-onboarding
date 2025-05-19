module "kv_engine" {
  source      = "../modules/kv-engine"
  path        = "shared/"
  description = "KV v2 secrets"
}

module "team1_kv_engine" {
  source      = "../modules/kv-engine"
  path        = "team1/"
  description = "Team 1 - KV v2 secrets"
}
