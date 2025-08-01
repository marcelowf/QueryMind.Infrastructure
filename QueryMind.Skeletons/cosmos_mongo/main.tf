resource "azurerm_cosmosdb_account" "mongo_account" {
  name                = var.cosmos_account_name
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  kind                = "MongoDB"

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  capabilities {
    name = "EnableMongo"
  }
}

resource "azurerm_cosmosdb_mongo_database" "mongo_db" {
  name                = var.database_name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.mongo_account.name
  throughput          = 400
}

resource "azurerm_cosmosdb_mongo_collection" "mongo_collection" {
  for_each = var.collections

  name                = each.key
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.mongo_account.name
  database_name       = azurerm_cosmosdb_mongo_database.mongo_db.name

  shard_key = each.value.shard_key

  index {
    keys   = ["_id"]
    unique = false
  }
}

