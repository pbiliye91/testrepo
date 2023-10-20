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
    ip_rules       = ["20.37.158.0/23",
"20.37.194.0/24",
"20.39.13.0/26",
"20.41.6.0/23",
"20.41.194.0/24",
"20.42.5.0/24",
"20.42.134.0/23",
"20.42.226.0/24",
"20.45.196.64/26",
"20.91.148.128/25",
"20.125.155.0/24",
"20.166.41.0/24",
"20.189.107.0/24",
"20.195.68.0/24",
"20.204.197.192/26",
"20.233.130.0/25",
"40.74.28.0/23",
"40.80.187.0/24",
"40.82.252.0/24",
"40.119.10.0/24",
"51.104.26.0/24",
"52.150.138.0/24",
"52.228.82.0/24",
"191.235.226.0/24"]
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