variable "subscription_id" {
  type      = string
  sensitive = true
}

variable "location" {
  type      = string
  sensitive = true
}

variable "tags" {
  type = map(string)
}

variable "env_suffix" {
  type = string
}

variable "common_app_settings" {
  type = map(string)
}

variable "key_vault_public_access" {
  type = bool
}

variable "database_name" {
  type = string
  default = "queryminddb${var.env_suffix}"
}