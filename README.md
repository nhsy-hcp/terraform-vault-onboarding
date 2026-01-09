# HCP Terraform Vault Integration

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

> **📖 Architecture & Design:** See [Solution Design Documentation](./docs/solution-design.md) for detailed architecture, authentication flows, and design decisions.

## Prerequisites

- Terraform >= 1.5.0
- HashiCorp Vault server
- HCP Terraform organization and API token
- Okta organization and API token (for OIDC authentication)
- [Task](https://taskfile.dev/) (optional, for automation)

## Workflow

The configurations should be applied in the following order:

1. **Bootstrap**: Sets up initial HCP Terraform projects, workspaces, and Vault JWT authentication
2. **Namespace Root**: Configures the root Vault namespace with OIDC authentication and identity groups
3. **Namespace Vending**: Creates child namespaces for business units with standardized configurations
4. **Business Unit Namespaces**: Individual BU namespaces can be customized independently

## Required Environment Variables

| Variable | Description |
|----------|-------------|
| `VAULT_ADDR` | Vault server address |
| `VAULT_TOKEN` | Vault authentication token |
| `VAULT_NAMESPACE` | Vault namespace (optional) |
| `TFE_TOKEN` | HCP Terraform API token |
| `OKTA_API_TOKEN` | Okta API token |

## Usage

### Using Taskfile

Initialize all configurations:

```bash
task init
```

Run bootstrap configuration:

```bash
task bootstrap
```

Plan namespace vending changes:

```bash
task namespace-vending
```

Format all Terraform files:

```bash
task lint
```

### Manual Terraform Commands

```bash
# Bootstrap
cd bootstrap
terraform init
terraform plan
terraform apply

# Namespace Vending
cd namespace-vending
terraform init
terraform plan
terraform apply
```

## Modules

### namespace

Creates a Vault namespace with:
- Namespace resource
- Admin and RBAC identity groups
- Quota rate limits and lease counts
- Namespace-specific policies

### workspace

Creates a HCP Terraform workspace integrated with Vault:
- TFC workspace resource
- Vault JWT auth backend role
- Workspace variables for Vault authentication
- Agent pool configuration (optional)

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
   - `backend.tf`
   - `providers.tf`
   - `variables.tf`
   - `main.tf`
4. Apply namespace-vending first, then the business unit configuration

## Policies

Vault policy HCL files are stored in the `policies/` directory:

| Policy | Description |
|--------|-------------|
| `tfc_admin_policy.hcl` | Full admin access for TFC workspaces |
| `tfc_namespace_admin_policy.hcl` | Namespace-scoped admin access |
| `namespace_admin_policy.hcl` | Namespace administrator permissions |
| `okta_vault_admin_policy.hcl` | Okta-authenticated admin permissions |

## Additional Resources

- [Vault Provider Documentation](https://registry.terraform.io/providers/hashicorp/vault/latest/docs)
- [TFE Provider Documentation](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs)
- [Okta Provider Documentation](https://registry.terraform.io/providers/okta/okta/latest/docs)
