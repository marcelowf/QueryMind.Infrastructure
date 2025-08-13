module "kv_01" {
  source              = "../QueryMind.Skeletons/key_vault"
  key_vault_name      = "kv-querymind-${var.env_suffix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_01.name
  tags                = var.tags

  access_policies = [
    {
      object_id           = data.azurerm_client_config.current.object_id
      key_permissions     = ["Get", "List", "Delete", "Purge", "Recover"]
      secret_permissions  = ["Get", "List", "Set", "Delete", "Purge", "Recover"]
      storage_permissions = ["Get", "List", "Set", "Delete", "Purge", "Recover"]
    },
    {
      object_id           = module.as_01.principal_id
      key_permissions     = ["Get", "List"]
      secret_permissions  = ["Get", "List"]
      storage_permissions = ["Get", "List"]
    },
    {
      object_id           = module.as_02.principal_id
      key_permissions     = ["Get", "List"]
      secret_permissions  = ["Get", "List"]
      storage_permissions = ["Get", "List"]
    },
    # Setando meu user azure como key-user
    {
      object_id           = "de50d8e1-495e-4135-8cb4-a471808b0ed6"
      key_permissions     = ["Get", "List", "Delete", "Purge", "Recover"]
      secret_permissions  = ["Get", "List", "Set", "Delete", "Purge", "Recover"]
      storage_permissions = ["Get", "List", "Set", "Delete", "Purge", "Recover"]
    },
    # ObjectID do meu Service Connection
    {
      object_id           = "dacb290c-4f58-4c7f-b62c-501d9d65f228"
      key_permissions     = ["Get", "List", "Delete", "Purge", "Recover"]
      secret_permissions  = ["Get", "List", "Set", "Delete", "Purge", "Recover"]
      storage_permissions = ["Get", "List", "Set", "Delete", "Purge", "Recover"]
    },
  ]
}

resource "azurerm_key_vault_secret" "backend_url" {
  name         = "BackendUrl"
  value        = format("https://%s.azurewebsites.net", module.as_01.app_service_name)
  key_vault_id = module.kv_01.id
}

resource "azurerm_key_vault_secret" "frontend_url" {
  name         = "FrontendUrl"
  value        = format("https://%s.azurewebsites.net", module.as_02.app_service_name)
  key_vault_id = module.kv_01.id
}

resource "random_password" "jwt_secret" {
  length  = 64
  special = true
}

resource "azurerm_key_vault_secret" "jwt_secret_key" {
  name         = "JwtSecretKey"
  value        = random_password.jwt_secret.result
  key_vault_id = module.kv_01.id

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [value]
  }
}

resource "azurerm_key_vault_secret" "db_connection_string" {
  name         = "ConnectionStrings--DefaultConnection"
  value        = module.cms_01.mongo_connection_string
  key_vault_id = module.kv_01.id
}

resource "azurerm_key_vault_secret" "db_database_name" {
  name         = "ConnectionStrings--DatabaseName"
  value        = "queryminddb${var.env_suffix}"
  key_vault_id = module.kv_01.id
}

resource "azurerm_key_vault_secret" "redis_connection_string" {
  name         = "RedisConnectionStrings--DefaultConnection"
  value        = "${module.arc_01.redis_name}:6380,password=${azurerm_redis_cache.arc_01.primary_access_key},ssl=True,abortConnect=False"
  key_vault_id = module.kv_01.id
}

resource "azurerm_key_vault_secret" "blob_connection_string" {
  name         = "BlobConnectionStrings--DefaultConnection"
  value        = module.sa_01.storage_account_primary_connection_string
  key_vault_id = module.kv_01.id
}

resource "azurerm_key_vault_secret" "blob_container_name" {
  name         = "BlobConnectionStrings--DefaultContainer"
  value        = "container-querymind-${var.env_suffix}"
  key_vault_id = module.kv_01.id
}
