resource "azurerm_key_vault" "main" {
  name                = "${var.project_name}-kv"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id
  tags                = local.tags

  enable_rbac_authorization = true
}

resource "azurerm_role_assignment" "kvofficer" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_key_vault_secret" "color" {
  name         = "color"
  value        = "AzureBlue"
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [azurerm_role_assignment.kvofficer]
}
