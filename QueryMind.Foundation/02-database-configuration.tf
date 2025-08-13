module "cms_01" {
  source              = "../QueryMind.Skeletons/cosmos_mongo"
  location            = azurerm_resource_group.rg_01.location
  resource_group_name = azurerm_resource_group.rg_01.name
  cosmos_account_name = "cms-querymind-${var.env_suffix}"
  database_name       = "queryminddb${var.env_suffix}"

  collections = {
    Users = {
      shard_key = "Id"
    }
    Conversations = {
      shard_key = "UserId"
    }
  }
}
