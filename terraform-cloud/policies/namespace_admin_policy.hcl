# List existing policies
path "sys/policies/acl"
{
  capabilities = ["list"]
}

# Create and manage ACL policies
path "sys/policies/acl/*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Manage auth methods broadly across Vault
path "auth/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Create, update, and delete auth methods
path "sys/auth/*"
{
  capabilities = ["create", "update", "delete", "sudo"]
}

# List auth methods
path "sys/auth"
{
  capabilities = ["read"]
}

# Managing identity
path "identity/*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Enable and manage the key/value secrets engine at `secret/` path
path "secret/*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}

# # Allow listing leases
# path "sys/leases/lookup" {
#   capabilities = ["list", "sudo"]
# }
#
# path "sys/leases/lookup/*" {
#   capabilities = ["list", "sudo"]
# }

# Allow managing leases
path "sys/leases/*"
{
  capabilities = ["read", "update", "list", "sudo"]
}

# Manage namespaces
path "sys/namespaces/*" {
   capabilities = ["create", "read", "update", "delete", "list"]
}

# Manage secrets engines
path "sys/mounts/*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}

# List existing secrets engines.
path "sys/mounts"
{
  capabilities = ["read"]
}

# Configure License
path "sys/license"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Configure Vault UI
path "sys/config/ui"
{
  capabilities = ["read", "update", "delete", "list"]
}

path "sys/license/status"
{
  capabilities = ["read"]
}

path "sys/internal/counters/activity"
{
  capabilities = ["read"]
}
