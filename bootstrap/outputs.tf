output "hcp_hvn_id" {
  value = hcp_hvn.vault.hvn_id
}

output "hcp_cluster_id" {
  value = hcp_vault_cluster.vault.cluster_id
}

output "hcp_public_endpoint" {
  value = hcp_vault_cluster.vault.vault_public_endpoint_url
}

output "hcp_private_endpoint" {
  value = hcp_vault_cluster.vault.vault_private_endpoint_url
}

output "hcp_admin_token" {
  value     = hcp_vault_cluster_admin_token.vault.token
  sensitive = true
}

output "namespace" {
  value = hcp_vault_cluster.vault.namespace
}

output "vault_version" {
  value = hcp_vault_cluster.vault.vault_version
}

output "state" {
  value = hcp_vault_cluster.vault.state
}
