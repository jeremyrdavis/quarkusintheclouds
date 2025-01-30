resource "azurerm_key_vault" "main" {
  name                        = var.keyvault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name = "standard"
  tenant_id = var.tenant_id

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.object_id

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
  name         =  var.keyvault_secret_name
  value        = var.keyvault_secret_value
  key_vault_id = azurerm_key_vault.main.id
}
