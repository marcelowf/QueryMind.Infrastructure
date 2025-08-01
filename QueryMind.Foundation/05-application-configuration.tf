module "asp_01" {
  source                = "../QueryMind.Skeletons/app_service_plan"
  app_service_plan_name = "asp-querymind-${var.env_suffix}"
  resource_group_name   = azurerm_resource_group.rg_01.name
  location              = var.location
  sku_name              = "B1"
  os_type               = "Linux"
  tags                  = var.tags
}

module "as_01" {
  source              = "../QueryMind.Skeletons/app_service"
  app_service_name    = "app-querymind-backend-${var.env_suffix}"
  resource_group_name = azurerm_resource_group.rg_01.name
  location            = var.location
  service_plan_id     = module.asp_01.id
  tags                = var.tags
  identity_type       = "SystemAssigned"

  app_settings = merge(
    var.common_app_settings,
    {
      "APPINSIGHTS_INSTRUMENTATIONKEY"        = module.app_insights_01.instrumentation_key
      "APPLICATIONINSIGHTS_CONNECTION_STRING" = module.app_insights_01.connection_string
    }
  )
}

module "as_02" {
  source              = "../QueryMind.Skeletons/app_service"
  app_service_name    = "app-querymind-frontend-${var.env_suffix}"
  resource_group_name = azurerm_resource_group.rg_01.name
  location            = var.location
  service_plan_id     = module.asp_01.id
  tags                = var.tags
  identity_type       = "SystemAssigned"

  app_settings = merge(
    var.common_app_settings,
    {
      "APPINSIGHTS_INSTRUMENTATIONKEY"        = module.app_insights_02.instrumentation_key
      "APPLICATIONINSIGHTS_CONNECTION_STRING" = module.app_insights_02.connection_string
    }
  )
}

module "app_insights_01" {
  source              = "../QueryMind.Skeletons/application_insights"
  name                = "appi-querymind-backend-${var.env_suffix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_01.name
  tags                = var.tags
}

module "app_insights_02" {
  source              = "../QueryMind.Skeletons/application_insights"
  name                = "appi-querymind-frontend-${var.env_suffix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_01.name
  tags                = var.tags
}
