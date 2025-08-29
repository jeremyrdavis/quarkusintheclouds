# User-assigned managed identity for Key Vault access
resource "azurerm_user_assigned_identity" "keyvault_identity" {
  name                = var.identity_name
  resource_group_name = var.resource_group_name
  location            = var.location
}

# Key Vault access policy for the managed identity
resource "azurerm_key_vault_access_policy" "managed_identity" {
  key_vault_id = var.key_vault_id
  tenant_id    = var.tenant_id
  object_id    = azurerm_user_assigned_identity.keyvault_identity.principal_id

  secret_permissions = [
    "Get",
    "List"
  ]

  key_permissions = [
    "Get",
    "List",
    "Decrypt",
    "Encrypt"
  ]

  certificate_permissions = [
    "Get",
    "List"
  ]
}