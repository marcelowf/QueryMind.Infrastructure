module "sa_01" {
  source                   = "../QueryMind.Skeletons/storage_account"
  sa_name                  = "saquerymind${var.env_suffix}"
  location                 = var.location
  resource_group_name      = azurerm_resource_group.rg_01.name
  tags                     = var.tags
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "scripts" {
  name                  = "container-querymind-${var.env_suffix}"
  storage_account_id    = module.sa_01.storage_account_id
  container_access_type = "blob"
}

module "arc_01" {
  source              = "../QueryMind.Skeletons/redis"
  name                = "arc-querymind-${var.env_suffix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_01.name
  sku_name            = "Basic"
  tags                = var.tags
}

# resource "azurerm_redis_firewall_rule" "arc_adm_rule" {
#   name                = "adm_ip"
#   resource_group_name = azurerm_resource_group.rg_01.name
#   redis_cache_name    = azurerm_redis_cache.arc_01.name
#   start_ip            = "MEU_IP"
#   end_ip              = "MEU_IP"
# }

# az redis list-keys --name redis_name --resource-group group_name
# arc-redis-test.redis.cache.windows.net:6380,password=REDIS_KEY=,ssl=True,abortConnect=False
