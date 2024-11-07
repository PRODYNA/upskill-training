resource "azurerm_log_analytics_workspace" "monitoring" {
  name                = "${local.resource_prefix}-law"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  daily_quota_gb      = 0.5
  tags                = local.tags
}

resource "azurerm_application_insights" "monitoring" {
  name                 = "${local.resource_prefix}-appi"
  location             = azurerm_resource_group.main.location
  resource_group_name  = azurerm_resource_group.main.name
  application_type     = "web"
  retention_in_days    = 30
  workspace_id         = azurerm_log_analytics_workspace.monitoring.id
  daily_data_cap_in_gb = 1
  tags                 = local.tags
}
