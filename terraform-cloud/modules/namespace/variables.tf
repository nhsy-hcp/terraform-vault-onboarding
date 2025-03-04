variable "namespace" {
  type = string
}

variable "description" {
  type = string
}

variable "admin_group_name" {
  type = string
}

variable "quota_lease_count" {
  type    = string
  default = 100
}

variable "quota_rate_limit" {
  type    = string
  default = 100
}
