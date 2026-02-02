# HCP Terraform Vault Integration

> **Disclaimer:** This project is provided for demonstration and learning purposes only. It is not intended for production use without proper security review, hardening, and customization for your specific environment.

This directory contains Terraform configurations for integrating HashiCorp Vault with HCP Terraform. It provides automated namespace provisioning, workspace management, and authentication setup for multi-tenant Vault environments.

## Directory Structure

```
terraform-vault-onboarding/
├── bootstrap/              # Initial HCP Terraform project and workspace setup
├── namespace-root/         # Root namespace configuration
├── namespace-vending/      # Automated namespace provisioning
├── namespace-bu01/         # Business Unit 1 namespace
├── namespace-bu02/         # Business Unit 2 namespace
├── namespace-bu03/         # Business Unit 3 namespace
├── modules/
│   ├── namespace/          # Vault namespace creation module
│   ├── workspace/          # HCP Terraform workspace + Vault integration module
│   └── kv-engine/          # KV secrets engine module
├── policies/               # Vault policy HCL files
├── scripts/                # Utility scripts for operations
├── docs/                   # Documentation
└── Taskfile.yml            # Task automation configuration
```

> **Architecture & Design:** See [Solution Design Documentation](./docs/solution-design.md) for detailed architecture, authentication flows, and design decisions.

## Prerequisites

- Terraform >= 1.14.0
- HCP Account (HashiCorp Cloud Platform)
- HashiCorp Vault (HCP Vault Cluster)
- HCP Terraform organization and API token
- Okta organization and API token (for OIDC authentication)
- [Task](https://taskfile.dev/) (optional, for automation)

## Workflow

The configurations should be applied in the following order:

1. **Bootstrap**: Sets up the HCP HVN and Vault Cluster, initial HCP Terraform projects, workspaces, and Vault JWT authentication.
2. **Namespace Root**: Configures the root Vault namespace with OIDC authentication and identity groups.
3. **Namespace Vending**: Creates child namespaces for business units with standardized configurations.
4. **Business Unit Namespaces**: Individual BU namespaces can be customized independently.

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
| `tfc_organization` | Terraform Cloud organization name | `"example-tfc-org"` | Yes |
| `tfc_project` | TFC project name | `"vault-onboarding"` | Yes |
| `tfc_token` | TFC API token (sensitive) | `"your-tfc-api-token"` | Yes |
| `hcp_project_id` | HCP Project ID | `"your-hcp-project-uuid"` | Yes |
| `okta_org_name` | OKTA organization name | `"your-okta-org-name"` | Yes |
| `okta_api_token` | OKTA API token (sensitive) | `"your-okta-api-token"` | Yes |
| `hcp_hvn_id` | HCP HVN identifier | `"vault-hvn"` | No (Default) |
| `hcp_vault_cluster_id` | HCP Vault cluster identifier | `"vault-cluster"` | No (Default) |
| `hcp_hvn_region` | AWS region for HCP HVN | `"eu-west-1"` | No (Default) |

**Note:** All HCP resource IDs are automatically suffixed with a random hex string to ensure global uniqueness.

### HCP Terraform Agent Setup (Optional)

TFC Agent pools are supported but disabled by default (`enable_tfc_agent_pool = false`). If your Vault cluster is set to a private endpoint, you will need to run agents within a network that can reach the HCP HVN (e.g., via VPC Peering or Transit Gateway).

**Note:** The previous `vault_address_tfc_agent` variable is obsolete as HCP Vault provides a consistent public or private endpoint URL.

## Usage
...
### workspace

Creates a HCP Terraform workspace integrated with Vault:
- HCP Terraform workspace resource
- Vault JWT auth backend role
- Workspace variables for Vault authentication
- Agent pool configuration (Optional, disabled by default)

### kv-engine

Manages KV v2 secrets engines within a namespace.

## Authentication

### HCP Terraform to Vault

Uses JWT authentication with OIDC. Workspaces are configured with bound claims to receive Vault tokens scoped to their assigned namespace and policies.

### Okta to Vault

OIDC authentication is configured in the root namespace. Users authenticate via Okta and receive tokens based on their group membership.

## Adding a New Business Unit

1. Create a namespace definition in `namespace-vending/bu{XX}.tf`
2. Create a dedicated directory `namespace-bu{XX}/`
3. Add the required files:
  - `main.tf`
  - `providers.tf`
  - `variables.tf`
4. Apply namespace-vending first, then the business unit configuration

## Policies

Vault policy HCL files are stored in the `policies/` directory:

| Policy | Description |
|--------|-------------|
| `tfc_admin_policy.hcl` | Full admin access for TFC workspaces |
| `tfc_namespace_admin_policy.hcl` | Namespace-scoped admin access |
| `namespace_admin_policy.hcl` | Namespace administrator permissions |
| `okta_vault_admin_policy.hcl` | Okta-authenticated admin permissions |

## Notes

- Do not use a self-signed certificate for Vault TLS or an OIDC workflow will error on login.

## Additional Resources

- [Vault Provider Documentation](https://registry.terraform.io/providers/hashicorp/vault/latest/docs)
- [TFE Provider Documentation](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs)
- [Okta Provider Documentation](https://registry.terraform.io/providers/okta/okta/latest/docs)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
