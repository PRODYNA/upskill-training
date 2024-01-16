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

# ############################
# ## STORAGE ACCOUNT VELERO ##
# ############################
# resource "azurerm_storage_account" "velero" {
#   name                     = substr(replace("${local.resource_prefix}-sa-velero", "-", ""), 0, 24) 
#   resource_group_name      = data.azurerm_resource_group.main.name
#   location                 = local.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
#   tags                     = local.tags
# }

# resource "azurerm_storage_container" "common_velero_backup" {
#   name                  = "velero-backup"
#   storage_account_name  = azurerm_storage_account.velero.name
#   container_access_type = "private"
# }