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
