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

module "team2_kv_engine" {
  source      = "../modules/kv-engine"
  path        = "team2/"
  description = "Team 2 - KV v2 secrets"
}

module "team3_kv_engine" {
  source      = "../modules/kv-engine"
  path        = "team3/"
  description = "Team 3 - KV v2 secrets"
}
