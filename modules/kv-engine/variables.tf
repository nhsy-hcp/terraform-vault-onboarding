variable "path" {
  description = "Path to mount the KV engine (e.g., secret/)"
  type        = string
}

variable "description" {
  description = "Description of the KV engine"
  type        = string
  default     = "KV v2 secrets engine"
}

variable "max_versions" {
  description = "Maximum number of versions to keep per secret"
  type        = number
  default     = 10
}
