variable "namespaces" {
  type = map(object({
    description = string
  }))
  default = {}
}