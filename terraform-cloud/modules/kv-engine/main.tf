resource "vault_mount" "kv" {
  path        = var.path
  type        = "kv"
  description = var.description

  options = {
    version      = "2"
    max_versions = tostring(var.max_versions)
  }
}
