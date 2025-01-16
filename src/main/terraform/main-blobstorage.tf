# Blob storage
resource "azurerm_storage_account" "main" {
  name                     = "${var.storage_account_name}${random_integer.num.result}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "ZRS"

}

