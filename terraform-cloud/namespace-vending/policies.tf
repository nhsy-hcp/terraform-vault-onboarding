data "vault_policy_document" "team_viewer" {
  for_each = toset(["team1", "team2", "team2"])
  rule {
    path         = "shared/data/${each.value}/*"
    capabilities = ["read", "list"]
  }
  rule {
    path         = "shared/metadata/${each.value}/*"
    capabilities = ["read", "list"]
  }
  rule {
    path         = "shared/metadata/"
    capabilities = ["list"]
  }
  rule {
    path         = "sys/mounts"
    capabilities = ["read"]
  }
}


data "vault_policy_document" "team_contributor" {
  for_each = toset(["team1", "team2", "team2"])
  rule {
    path         = "shared/data/${each.value}/*"
    capabilities = ["create", "update", "read", "list"]
  }
  rule {
    path         = "shared/metadata/${each.value}/*"
    capabilities = ["read", "list"]
  }
  rule {
    path         = "shared/metadata/"
    capabilities = ["list"]
  }
  rule {
    path         = "sys/mounts"
    capabilities = ["read"]
  }
}
