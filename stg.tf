resource "azurerm_storage_account" "gen_storage_account" {
  name                          = "pubstg2013"
  resource_group_name           = "vishal-resource-group"
  location                      = "westeurope"
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  enable_https_traffic_only     = true
  public_network_access_enabled = true
  depends_on  = [azurerm_resource_group.my_resource_group]

  network_rules {
    default_action = "Deny"
    ip_rules       = [
          "4.175.0.0/16",
          "4.180.0.0/16",
          "4.210.128.0/17",
          "4.231.0.0/17",
          "4.245.0.0/17",
          "13.69.0.0/17",
          "13.73.128.0/18",
          "13.73.224.0/21",
          "13.80.0.0/15",
          "13.88.200.0/21",
          "13.93.0.0/17",
          "13.94.128.0/17",
          "13.95.0.0/16",
          "13.104.145.192/26",
          "13.104.146.0/26",
          "13.104.146.128/25",
          "13.104.158.176/28",
          "13.104.209.0/24",
          "13.104.214.0/25",
          "13.104.218.128/25",
          "13.105.22.0/24",
          "13.105.23.128/25",
          "13.105.28.32/28",
          "13.105.29.128/25",
          "13.105.60.48/28",
          "13.105.60.96/27",
          "13.105.60.128/27",
          "13.105.66.144/28",
          "13.105.105.96/27",
          "13.105.105.128/28",
          "13.105.105.160/27",
          ]
  }

  blob_properties {
    #Specifies the number of days that the container should be retained.
    container_delete_retention_policy {
      days = 7
    }
    #Specifies the number of days that the blob should be retained
    delete_retention_policy {
      days = 7
    }
  }
}

resource "azurerm_storage_container" "gen_stg_acc_container_1" {
  name                  = "tblc-sb-cnt-dev-we-1"
  storage_account_name  = azurerm_storage_account.gen_storage_account.name
  container_access_type = "private"
}

resource "azurerm_storage_share" "fileshare" {
  name                 = "bulkfilesdev"
  storage_account_name = azurerm_storage_account.gen_storage_account.name
  quota                = 50
}

resource "azurerm_storage_share_directory" "file_share_directories" {
  share_name           = "bulkfilesdev"
  storage_account_name = azurerm_storage_account.gen_storage_account.name
  name                 = "errors"
  depends_on           = [azurerm_storage_share.fileshare]
}

resource "azurerm_storage_share_directory" "file_share_directories_new" {
  share_name           = "bulkfilesdev"
  storage_account_name = azurerm_storage_account.gen_storage_account.name
  name                 = "errorsnew"
  depends_on           = [azurerm_storage_share.fileshare]
}

resource "azurerm_storage_share_directory" "file_share_directories_new1" {
  share_name           = "bulkfilesdev"
  storage_account_name = azurerm_storage_account.gen_storage_account.name
  name                 = "errorsnew1"
  depends_on           = [azurerm_storage_share.fileshare]
}