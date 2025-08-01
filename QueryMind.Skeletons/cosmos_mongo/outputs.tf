output "cosmos_account_name" {
  value = azurerm_cosmosdb_account.mongo_account.name
}

output "mongo_database_name" {
  value = azurerm_cosmosdb_mongo_database.mongo_db.name
}

output "mongo_collection_name" {
  value = { for key, collection in azurerm_cosmosdb_mongo_collection.mongo_collection : key => collection.name }
}

output "cosmosdb_account_endpoint" {
  value = azurerm_cosmosdb_account.mongo_account.endpoint
}

output "mongo_connection_string" {
  value = azurerm_cosmosdb_account.mongo_account.primary_mongodb_connection_string
}
