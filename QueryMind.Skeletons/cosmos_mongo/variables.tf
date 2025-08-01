variable "location" {
  type        = string
  description = "Location/region for Cosmos DB."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}

variable "cosmos_account_name" {
  type        = string
  description = "The name of the Cosmos DB account."
}

variable "database_name" {
  type        = string
  description = "The name of the MongoDB database."
  default     = "appdb"
}

variable "collections" {
  type = map(object({
    shard_key = string
  }))
}
