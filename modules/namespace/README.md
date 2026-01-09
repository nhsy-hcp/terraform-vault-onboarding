# namespace

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.12.0 |
| <a name="requirement_okta"></a> [okta](#requirement\_okta) | ~> 4.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_okta"></a> [okta](#provider\_okta) | 4.14.0 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | 4.6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [vault_identity_group.namespace_admin_external](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group) | resource |
| [vault_identity_group.namespace_admin_internal](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group) | resource |
| [vault_identity_group.rbac_external](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group) | resource |
| [vault_identity_group.rbac_internal](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group) | resource |
| [vault_identity_group_alias.namespace_admin_external](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group_alias) | resource |
| [vault_identity_group_alias.rbac_external](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group_alias) | resource |
| [vault_namespace.default](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/namespace) | resource |
| [vault_policy.namespace_admin](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy) | resource |
| [vault_policy.rbac](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy) | resource |
| [vault_quota_lease_count.namespace](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/quota_lease_count) | resource |
| [vault_quota_rate_limit.namespace](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/quota_rate_limit) | resource |
| [okta_group.namespace_admin](https://registry.terraform.io/providers/okta/okta/latest/docs/data-sources/group) | data source |
| [okta_group.rbac](https://registry.terraform.io/providers/okta/okta/latest/docs/data-sources/group) | data source |
| [vault_auth_backend.okta](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/auth_backend) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_group_name"></a> [admin\_group\_name](#input\_admin\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | n/a | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | n/a | `string` | n/a | yes |
| <a name="input_okta_auth_path"></a> [okta\_auth\_path](#input\_okta\_auth\_path) | n/a | `string` | `"oidc"` | no |
| <a name="input_quota_lease_count"></a> [quota\_lease\_count](#input\_quota\_lease\_count) | n/a | `string` | `100` | no |
| <a name="input_quota_rate_limit"></a> [quota\_rate\_limit](#input\_quota\_rate\_limit) | n/a | `string` | `100` | no |
| <a name="input_rbac_delegation"></a> [rbac\_delegation](#input\_rbac\_delegation) | n/a | <pre>map(object({<br/>    group_name = string,<br/>    policies   = map(string),<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_namespace"></a> [namespace](#output\_namespace) | n/a |
| <a name="output_rbac_delegation"></a> [rbac\_delegation](#output\_rbac\_delegation) | n/a |
<!-- END_TF_DOCS -->
