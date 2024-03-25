path "sys/namespaces/*" {
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
# Create and manage ACL policies
path "sys/policies/acl/*" {
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
# List ACL policies
path "sys/policies/acl" {
    capabilities = ["list"]
}
# Create and manage quota policies
path "sys/quotas/*" {
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
# Read auth mounts
path "sys/mounts/auth" {
    capabilities = ["read"]
}
path "sys/mounts/auth/*" {
    capabilities = ["read"]
}
# Manage tokens
path "auth/token/*" {
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
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
# Create and manage namespace ACL policies
path "+/sys/policies/acl/*" {
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
# List namespace ACL policies
path "+/sys/policies/acl" {
    capabilities = ["list"]
}
## Create and manage namespace ACL policies
#path "root/+/sys/policies/acl/*" {
#    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
#}
## List namespace ACL policies
#path "root/+/sys/policies/acl" {
#    capabilities = ["list"]
#}