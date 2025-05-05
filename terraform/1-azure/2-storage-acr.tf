# ########################
# ## CONTAINER REGISTRY ##
# ########################
#
# resource "azurerm_container_registry" "main" {
#   location            = azurerm_resource_group.main.location
#   name                = substr(replace("${local.resource_prefix}cr", "-", ""), 0, 32)
#   resource_group_name = azurerm_resource_group.main.name
#   sku                 = "Basic"
#   tags                = local.tags
#   admin_enabled       = true
# }
