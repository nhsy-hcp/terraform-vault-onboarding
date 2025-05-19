<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_vault"></a> [vault](#provider\_vault) | 4.8.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kv_engine"></a> [kv\_engine](#module\_kv\_engine) | ../modules/kv-engine | n/a |

## Resources

| Name | Type |
|------|------|
| [vault_identity_group.dev12345](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_okta_base_url"></a> [okta\_base\_url](#input\_okta\_base\_url) | Okta base URL | `string` | `"okta.com"` | no |
| <a name="input_okta_org_name"></a> [okta\_org\_name](#input\_okta\_org\_name) | Okta organization name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
