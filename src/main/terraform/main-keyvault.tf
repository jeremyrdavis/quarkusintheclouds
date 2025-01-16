resource "azurerm_key_vault" "main" {
  name                        = "${var.keyvault_name}-${random_integer.num.result}"
  location                    = var.location
  resource_group_name         = azurerm_resource_group.main.name
  enabled_for_disk_encryption = true
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name = "standard"
  tenant_id = data.azurerm_client_config.current.tenant_id

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
      "List",
      "Create",
      "Delete",
      "Purge"
    ]

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Purge"
    ]

    storage_permissions = [
      "Get",
      "List",
      "Set"
    ]
  }
}

resource "azurerm_key_vault_secret" "secret1" {
  name         =  "${var.keyvault_secret_name}-${random_integer.num.result}"
  value        = "${var.keyvault_secret_value}-${random_integer.num.result}"
  key_vault_id = azurerm_key_vault.main.id
}
