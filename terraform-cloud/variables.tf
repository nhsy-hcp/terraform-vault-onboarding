variable "namespaces" {
  type = map(object({
    name = string
  }))
  default = {}
}