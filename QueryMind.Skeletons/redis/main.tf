locals {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
  tags                = var.tags
}

resource "azurerm_redis_cache" "arc_01" {
  name                          = local.name
  location                      = local.location
  resource_group_name           = local.resource_group_name
  capacity                      = 2
  family                        = "C"
  sku_name                      = local.sku_name
  non_ssl_port_enabled          = false
  minimum_tls_version           = "1.2"
  public_network_access_enabled = true
  tags                          = local.tags

  redis_configuration {}
}
