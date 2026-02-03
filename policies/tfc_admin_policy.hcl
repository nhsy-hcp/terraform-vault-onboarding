#path "sys/namespaces/*" {
#    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
#}
# Create and manage ACL policies
path "sys/policies/acl/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# List ACL policies
path "sys/policies/acl" {
  capabilities = ["list"]
}

## Create and manage quota policies
#path "sys/quotas/*" {
#    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
#}
## Read auth mounts
#path "sys/mounts/auth" {
#    capabilities = ["read"]
#}
#path "sys/mounts/auth/*" {
#    capabilities = ["read"]
#}
### Manage tokens
##path "auth/token/*" {
##    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
##}
## Allow tokens to query themselves
#path "auth/token/lookup-self" {
#  capabilities = ["read"]
#}
## Allow tokens to renew themselves
#path "auth/token/renew-self" {
#    capabilities = ["update"]
#}
## Allow tokens to revoke themselves
#path "auth/token/revoke-self" {
#    capabilities = ["update"]
#}
## Create and manage identities
#path "identity/*" {
#    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
#}
## List identities
#path "identity" {
#    capabilities = ["list"]
#}
## Create and manage identities
#path "+/identity/*" {
#    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
#}
## List identities
#path "+/identity" {
#    capabilities = ["list"]
#}
## Create and manage namespace ACL policies
#path "+/sys/policies/acl/*" {
#    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
#}
## List namespace ACL policies
#path "+/sys/policies/acl" {
#    capabilities = ["list"]
#}
### Create and manage namespace ACL policies
##path "root/+/sys/policies/acl/*" {
##    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
##}
### List namespace ACL policies
##path "root/+/sys/policies/acl" {
##    capabilities = ["list"]
##}

path "auth/token/create" {
  capabilities = ["update"]
}

path "sys/namespaces/*" {
  capabilities = ["read", "update", "delete"]
}

path "+/sys/policies/acl/*" {
  capabilities = ["create", "read", "update", "delete"]
}

# Create and manage identities
path "identity/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# List identities
path "identity" {
  capabilities = ["list"]
}

# Create and manage identities
path "+/identity/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# List identities
path "+/identity" {
  capabilities = ["list"]
}

# Create and manage auth jwt mounts
path "auth/jwt" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "auth/jwt/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "+/auth/jwt" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "+/auth/jwt/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Create and manage auth oidc mounts
path "auth/oidc" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "auth/oidc/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "sys/auth" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "sys/auth/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "+/sys/auth" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "+/sys/auth/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "sys/mounts/auth" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "sys/mounts/auth/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "+/sys/mounts/auth" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "+/sys/mounts/auth/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Create and manage quota policies
path "sys/quotas/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
