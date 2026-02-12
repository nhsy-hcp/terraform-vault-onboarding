# Terraform Vault Onboarding

> **Disclaimer:** This project is provided for demonstration and learning purposes only. It is not intended for production use without proper security review, hardening, and customization for your specific environment.

This directory contains Terraform configurations for integrating HCP Vault with HCP Terraform. It provides automated namespace provisioning, workspace management, and authentication setup for multi-tenant Vault environments.

## Directory Structure

```
terraform-vault-onboarding/
├── bootstrap/              # Initial HCP Terraform project and workspace setup
├── namespace-root/         # Root namespace configuration
├── namespace-vending/      # Automated namespace provisioning
├── namespace-tn001/         # Tenant 1 namespace
├── namespace-tn002/         # Tenant 2 namespace
├── namespace-tn003/         # Tenant 3 namespace
├── modules/
│   ├── namespace/          # HCP Vault namespace creation module
│   ├── workspace/          # HCP Terraform workspace + HCP Vault integration module
│   └── kv-engine/          # KV secrets engine module
├── policies/               # HCP Vault policy HCL files
├── scripts/                # Utility scripts for operations
├── docs/                   # Documentation
└── Taskfile.yml            # Task automation configuration
```

### Monorepo Structure

This project uses a monorepo structure for simplification and ease of demonstration. All components (bootstrap, namespace-root, namespace-vending, and tenant namespaces) are contained in a single repository.

> **Production Recommendation:** For production deployments, it is recommended to separate `namespace-vending`, individual tenant namespaces (`namespace-tn001`, `namespace-tn002`, etc.), and the `modules/` directory into their own repositories. This separation provides:
> - **Improved isolation**: Tenant teams can manage their own repositories with appropriate access controls
> - **Independent CI/CD**: Each tenant can have separate pipelines and deployment schedules
> - **Better security boundaries**: Reduces the risk of accidental cross-tenant modifications
> - **Scalability**: As the number of tenants grows, separate repositories prevent a single monorepo from becoming unwieldy
> - **Module versioning**: Separate module repositories enable proper semantic versioning and controlled rollout of changes
> - **Reusability**: Modules can be published to a private Terraform registry and shared across multiple projects

> **Architecture & Design:** See [Solution Design Documentation](./docs/solution-design.md) for detailed architecture, authentication flows, and design decisions.

## Prerequisites

- Terraform >= 1.14.0
- HCP account (HashiCorp Cloud Platform)
- HCP Vault (HCP Vault Cluster)
- HCP Terraform organization and API token
- Okta organization and API token (for OIDC authentication)
- [Task](https://taskfile.dev/) (optional, for automation)

## Workflow

The configurations should be applied in the following order:

1. **Bootstrap**: Sets up the HCP HVN and HCP Vault Cluster, initial HCP Terraform projects, workspaces, and HCP Vault JWT authentication.
2. **Namespace Root**: Configures the HCP Vault (admin) namespace with OIDC authentication and identity groups.
3. **Namespace Vending**: Creates child namespaces for tenants with standardized configurations.
4. **Tenant Namespaces**: Individual tenant namespaces can be customized independently.

## Bootstrap Demo Setup

The bootstrap phase creates demo resources in OKTA for testing and demonstration purposes. It also handles the infrastructure setup on HCP:

- **HCP Networking**: Creates a HashiCorp Virtual Network (HVN).
- **HCP Vault**: Provisions a Vault cluster with randomized IDs for uniqueness.
- **Demo Users**: Configurable test users with credentials (defined in `okta_users` variable).
...
### Terraform Variables

Copy the example terraform variables file and update it with your values:

```bash
cp ./bootstrap/terraform.tfvars.example ./bootstrap/terraform.tfvars
```

Edit `./bootstrap/terraform.tfvars` and configure the following variables:

| Variable | Description | Example | Required |
|----------|-------------|---------|----------|
| `github_organization` | GitHub organization name | `"example-org"` | Yes |
| `github_repository` | Repository name | `"terraform-vault-onboarding"` | Yes |
| `tfc_organization` | HCP Terraform organization name | `"example-tfc-org"` | Yes |
| `tfc_project` | HCP Terraform project name | `"vault-onboarding"` | Yes |
| `tfc_token` | HCP Terraform API token (sensitive) | `"your-tfc-api-token"` | Yes |
| `hcp_project_id` | HCP Project ID | `"your-hcp-project-uuid"` | Yes |
| `okta_org_name` | OKTA organization name | `"your-okta-org-name"` | Yes |
| `okta_api_token` | OKTA API token (sensitive) | `"your-okta-api-token"` | Yes |
| `hcp_hvn_id` | HCP HVN identifier | `"vault-hvn"` | No (Default) |
| `hcp_vault_cluster_id` | HCP Vault cluster identifier | `"vault-cluster"` | No (Default) |
| `hcp_hvn_region` | AWS region for HCP HVN | `"eu-west-1"` | No (Default) |

**Note:** All HCP resource IDs are automatically suffixed with a random hex string to ensure global uniqueness.

## Usage

The project uses a vending pattern where namespaces and workspaces are centrally managed, while tenants configure their own resources (like KV engines) within their assigned namespace.

### Namespace Vending

Defined in `namespace-vending/tn001.tf`, this creates the Vault namespace and the corresponding TFC workspace.

```hcl
module "tn001_namespace" {
  source           = "../modules/namespace"
  namespace        = "tn001"
  description      = "Tenant 1 namespace"
  admin_group_name = "vault-tn001-admin"
}

module "tn001_workspace" {
  source = "../modules/workspace"

  tfc_organization      = var.tfc_organization
  tfc_project           = var.tfc_project
  tfc_workspace         = "vault-onboarding-namespace-tn001"
  tfc_working_directory = "./namespace-tn001"

  vault_address         = var.vault_address
  vault_namespace       = module.tn001_namespace.namespace
}
```

### Tenant Configuration

Defined in `namespace-tn001/main.tf`, tenants manage their own secrets engines and other resources.

```hcl
module "kv_engine" {
  source      = "../modules/kv-engine"
  path        = "shared/"
  description = "KV v2 secrets"
}
```

## Authentication

### HCP Terraform to HCP Vault

Uses JWT authentication with OIDC. Workspaces are configured with bound claims to receive HCP Vault tokens scoped to their assigned namespace and policies.

### Okta to HCP Vault

OIDC authentication is configured in the root HCP Vault namespace. Users authenticate via Okta and receive tokens based on their group membership.

## Adding a New Tenant

1. Create a namespace definition in `namespace-vending/tn{XXX}.tf`
2. Create a dedicated directory `namespace-tn{XXX}/`
3. Add the required files:
  - `main.tf`
  - `providers.tf`
  - `variables.tf`
4. Apply namespace-vending first, then the tenant configuration

## Policies

HCP Vault policy HCL files are stored in the `policies/` directory:

| Policy | Description |
|--------|-------------|
| `tfc_admin_policy.hcl` | Full admin access for HCP Terraform workspaces |
| `tfc_namespace_admin_policy.hcl` | Namespace-scoped admin access |
| `namespace_admin_policy.hcl` | Namespace administrator permissions |
| `vault_admin_policy.hcl` | Vault Admin ACL policy |

## Development

### Linting & Formatting

The project uses `pre-commit` and `tflint` for code quality.

- **Pre-commit**: Runs automatically on commit if installed (`pre-commit install`). Can be run manually via `task lint`.
- **Formatting**: Enforced via `terraform fmt`.
- **Linting**: Uses `tflint` with recursive checks across all modules.

## Additional Resources

- [Vault Provider Documentation](https://registry.terraform.io/providers/hashicorp/vault/latest/docs)
- [TFE Provider Documentation](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs)
- [Okta Provider Documentation](https://registry.terraform.io/providers/okta/okta/latest/docs)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
