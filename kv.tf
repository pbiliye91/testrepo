data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "keyvault" {
  name                          = "v-sb-gen-dev-we-1"
  location                      = "West Europe"
  resource_group_name           = "vishal-resource-group"
  enabled_for_disk_encryption   = true
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days    = 7
  purge_protection_enabled      = false
  sku_name                      = "standard"
  public_network_access_enabled = true
  

}