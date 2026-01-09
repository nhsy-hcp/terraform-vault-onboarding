# namespace-vending

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.12.0 |
| <a name="requirement_okta"></a> [okta](#requirement\_okta) | ~> 4.0 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | ~> 0.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_vault"></a> [vault](#provider\_vault) | 4.6.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bu01_namespace"></a> [bu01\_namespace](#module\_bu01\_namespace) | ../modules/namespace | n/a |
| <a name="module_bu01_workspace"></a> [bu01\_workspace](#module\_bu01\_workspace) | ../modules/workspace | n/a |
| <a name="module_bu02_namespace"></a> [bu02\_namespace](#module\_bu02\_namespace) | ../modules/namespace | n/a |
| <a name="module_bu02_workspace"></a> [bu02\_workspace](#module\_bu02\_workspace) | ../modules/workspace | n/a |
| <a name="module_bu03_namespace"></a> [bu03\_namespace](#module\_bu03\_namespace) | ../modules/namespace | n/a |
| <a name="module_bu03_workspace"></a> [bu03\_workspace](#module\_bu03\_workspace) | ../modules/workspace | n/a |

## Resources

| Name | Type |
|------|------|
| [vault_policy_document.dedicated_team_contributor](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/policy_document) | data source |
| [vault_policy_document.dedicated_team_viewer](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/policy_document) | data source |
| [vault_policy_document.shared_team_contributor](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/policy_document) | data source |
| [vault_policy_document.shared_team_viewer](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_tfc_agent_pool"></a> [enable\_tfc\_agent\_pool](#input\_enable\_tfc\_agent\_pool) | n/a | `bool` | `true` | no |
| <a name="input_github_organization"></a> [github\_organization](#input\_github\_organization) | Name of the GitHub organization. | `string` | n/a | yes |
| <a name="input_github_repository"></a> [github\_repository](#input\_github\_repository) | Name of the GitHub repository. | `string` | n/a | yes |
| <a name="input_okta_api_token"></a> [okta\_api\_token](#input\_okta\_api\_token) | Okta API token | `string` | n/a | yes |
| <a name="input_okta_auth_path"></a> [okta\_auth\_path](#input\_okta\_auth\_path) | n/a | `string` | `"oidc"` | no |
| <a name="input_okta_base_url"></a> [okta\_base\_url](#input\_okta\_base\_url) | Okta base URL | `string` | `"okta.com"` | no |
| <a name="input_okta_org_name"></a> [okta\_org\_name](#input\_okta\_org\_name) | Okta organization name | `string` | n/a | yes |
| <a name="input_tfc_organization"></a> [tfc\_organization](#input\_tfc\_organization) | Name of the TFC organization. | `string` | n/a | yes |
| <a name="input_tfc_project"></a> [tfc\_project](#input\_tfc\_project) | Name of the TFC project. | `string` | n/a | yes |
| <a name="input_tfc_working_directory_prefix"></a> [tfc\_working\_directory\_prefix](#input\_tfc\_working\_directory\_prefix) | Working directory for the TFC workspace. | `string` | `"."` | no |
| <a name="input_tfc_workspace_prefix"></a> [tfc\_workspace\_prefix](#input\_tfc\_workspace\_prefix) | Name of the TFC workspace. | `string` | `"terraform-vault-onboarding"` | no |
| <a name="input_vault_address"></a> [vault\_address](#input\_vault\_address) | Vault API endpoint | `string` | n/a | yes |
| <a name="input_vault_auth_path"></a> [vault\_auth\_path](#input\_vault\_auth\_path) | Mount path where JWT Auth will be configured | `string` | n/a | yes |
| <a name="input_vault_auth_role"></a> [vault\_auth\_role](#input\_vault\_auth\_role) | Vault role name | `string` | `"tfc-namespace-admin"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
