output "redis_primary_key" {
  value     = azurerm_redis_cache.arc_01.primary_access_key
  sensitive = true
}

output "redis_name" {
  value     = azurerm_redis_cache.arc_01.name
  sensitive = true
}
