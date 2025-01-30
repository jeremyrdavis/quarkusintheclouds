resource "azurerm_role_assignment" "appconf_dataowner" {
  scope                = var.resource_group_id
  role_definition_name = "App Configuration Data Owner"
  principal_id         = var.role_id
}

resource "azurerm_app_configuration" "appconf" {
  name                = var.app_config_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "standard"
  depends_on = [
    azurerm_role_assignment.appconf_dataowner
  ]
}

resource "azurerm_app_configuration_key" "key_one" {
  configuration_store_id = azurerm_app_configuration.appconf.id
  key                  = "myKeyOne-${var.app_config_name}"
  value                = "qaz1-${var.app_config_name}"
}

resource "azurerm_app_configuration_key" "key_two" {
  configuration_store_id = azurerm_app_configuration.appconf.id
  key                  = "myKeyTwo-${var.app_config_name}"
  value                = "qaz2-${var.app_config_name}"
  depends_on = [
    azurerm_role_assignment.appconf_dataowner
  ]
}
