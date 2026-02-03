data "vault_identity_group" "global_admin" {
  group_name = "vault-admin-external"
}

data "vault_policy_document" "shared_team_viewer" {
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


data "vault_policy_document" "shared_team_contributor" {
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

data "vault_policy_document" "dedicated_team_viewer" {
  for_each = toset(["team1", "team2", "team2"])
  rule {
    path         = "${each.value}/data/*"
    capabilities = ["read", "list"]
  }
  rule {
    path         = "${each.value}/metadata/*"
    capabilities = ["read", "list"]
  }
  rule {
    path         = "${each.value}/metadata/"
    capabilities = ["list"]
  }
  rule {
    path         = "sys/mounts"
    capabilities = ["read"]
  }
}


data "vault_policy_document" "dedicated_team_contributor" {
  for_each = toset(["team1", "team2", "team2"])
  rule {
    path         = "${each.value}/data/*"
    capabilities = ["create", "update", "read", "list"]
  }
  rule {
    path         = "${each.value}/metadata/*"
    capabilities = ["read", "list"]
  }
  rule {
    path         = "${each.value}/metadata/"
    capabilities = ["list"]
  }
  rule {
    path         = "sys/mounts"
    capabilities = ["read"]
  }
}
