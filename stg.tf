resource "azurerm_storage_account" "gen_storage_account" {
  name                          = "pubstg2013"
  resource_group_name           = "vishal-resource-group"
  location                      = "westeurope"
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  enable_https_traffic_only     = true
  public_network_access_enabled = false
  depends_on  = [azurerm_resource_group.my_resource_group]

  network_rules {
    default_action = "Allow"
    ip_rules       = ["40.74.28.0/23"]
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