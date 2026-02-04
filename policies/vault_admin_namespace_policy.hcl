# Manage auth methods in child namespaces
path "+/sys/auth" {
  capabilities = ["read"]
}

path "+/sys/auth/*" {
  capabilities = ["create", "update", "delete", "sudo"]
}

# Manage secrets engines in child namespaces
path "+/sys/mounts" {
  capabilities = ["read"]
}

path "+/sys/mounts/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Manage ACL policies in child namespaces
path "+/sys/policies/acl" {
  capabilities = ["list"]
}

path "+/sys/policies/acl/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Manage identity in child namespaces
path "+/identity/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
