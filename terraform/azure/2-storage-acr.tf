########################
## CONTAINER REGISTRY ##
########################

resource "azurerm_container_registry" "main" {
  location            = local.location
  name                = substr(replace("${local.resource_prefix}-acr-main", "-", ""), 0, 32)
  resource_group_name = data.azurerm_resource_group.main.name
  sku                 = "Basic"
  tags                = local.tags
  admin_enabled       = true
}
