# bootstrap

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.2.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_vault"></a> [vault](#provider\_vault) | 3.24.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [vault_jwt_auth_backend.github](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/jwt_auth_backend) | resource |
| [vault_jwt_auth_backend_role.github_admin](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/jwt_auth_backend_role) | resource |
| [vault_policy.github_admin](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy) | resource |
| [vault_policy_document.github_admin](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_lease_ttl"></a> [default\_lease\_ttl](#input\_default\_lease\_ttl) | Default lease TTL for Vault tokens | `string` | `"10m"` | no |
| <a name="input_github_organization"></a> [github\_organization](#input\_github\_organization) | Name of the GitHub organization. | `string` | n/a | yes |
| <a name="input_github_repository"></a> [github\_repository](#input\_github\_repository) | Name of the GitHub repository. | `string` | `"terraform-vault-onboarding"` | no |
| <a name="input_max_lease_ttl"></a> [max\_lease\_ttl](#input\_max\_lease\_ttl) | Maximum lease TTL for Vault tokens | `string` | `"30m"` | no |
| <a name="input_token_type"></a> [token\_type](#input\_token\_type) | Token type for Vault tokens | `string` | `"default-service"` | no |
| <a name="input_vault_auth_mount_path"></a> [vault\_auth\_mount\_path](#input\_vault\_auth\_mount\_path) | the mount path where JWT Auth will be configured | `string` | `"jwt_github"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
