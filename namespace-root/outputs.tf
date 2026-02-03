output "vault_admin_group_id" {
  value       = vault_identity_group.vault_admin.id
  description = "The ID of the global vault-admin external identity group."
}

output "vault_user_group_id" {
  value       = vault_identity_group.vault_user.id
  description = "The ID of the global vault-user external identity group."
}
