terraform {
  required_version = ">= 0.15.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.61"
    }
  }
  backend "azurerm" {
    resource_group_name  = "mcmd-dev-rg"
    storage_account_name = "samlinkstorage1234"
    container_name       = "test-vm"
    key                  = "test-vm/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "my_resource_group" {
  name     = "vishal-resource-group"
  location = "West Europe"
}

resource "azurerm_virtual_network" "my_virtual_network" {
  name                = "my-virtual-network"
  address_space       = ["10.5.0.0/16"]
  location            = azurerm_resource_group.my_resource_group.location
  resource_group_name = azurerm_resource_group.my_resource_group.name
}

resource "azurerm_subnet" "my_subnet" {
  name                 = "my-subnet"
  resource_group_name  = azurerm_resource_group.my_resource_group.name
  virtual_network_name = azurerm_virtual_network.my_virtual_network.name
  address_prefixes     = ["10.5.0.0/24"]

}

resource "azurerm_network_security_group" "my_nsg" {
  name                = "my-nsg"
  location            = azurerm_resource_group.my_resource_group.location
  resource_group_name = azurerm_resource_group.my_resource_group.name


  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

resource "azurerm_network_interface_security_group_association" "association" {
  network_interface_id      = azurerm_network_interface.my_nic.id
  network_security_group_id = azurerm_network_security_group.my_nsg.id
}

resource "azurerm_network_interface" "my_nic" {
  name                = "my-nic"
  location            = azurerm_resource_group.my_resource_group.location
  resource_group_name = azurerm_resource_group.my_resource_group.name

  ip_configuration {
    name                          = "my-nic-config"
    subnet_id                     = azurerm_subnet.my_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_public_ip" "public_ip" {
  name                = "public_ip"
  resource_group_name = azurerm_resource_group.my_resource_group.name
  location            = azurerm_resource_group.my_resource_group.location
  sku                 = "Standard"
  allocation_method   = "Static"
}


resource "azurerm_windows_virtual_machine" "my_vm" {
  name                  = "my-vm"
  location              = azurerm_resource_group.my_resource_group.location
  resource_group_name   = azurerm_resource_group.my_resource_group.name
  network_interface_ids = [azurerm_network_interface.my_nic.id]
  size                  = "Standard_DS2_v2"
  timezone = "FLE Standard Time"

  admin_username = "user1234"
  admin_password = var.vm_login_password

  os_disk {
    name                 = "my-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
}



resource "azurerm_virtual_machine_extension" "my_extension" {
  name                       = "my-extension"
  virtual_machine_id         = azurerm_windows_virtual_machine.my_vm.id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.10"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "commandToExecute": "powershell.exe Install-WindowsFeature -Name NET-Framework-Features -IncludeManagementTools -Verbose; powershell.exe Install-WindowsFeature -Name MSMQ-Services -IncludeManagementTools -Verbose; powershell.exe Restart-Computer -Force"
    }
SETTINGS
}



/*
resource "azurerm_virtual_machine_extension" "my_extension" {
  name                       = "my-extension"
  virtual_machine_id         = azurerm_windows_virtual_machine.my_vm.id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.10"
  auto_upgrade_minor_version = true
  
  settings = <<SETTINGS
{
  "fileUris": [
    "https://samplinkdfor12124.blob.core.windows.net/testsamsb/framwork48_install_script.ps1"
  ],

  "commandToExecute": "powershell.exe Install-WindowsFeature -Name Web-Server -IncludeManagementTools -Verbose ; powershell.exe Install-WindowsFeature -Name Messaging-Queue -IncludeManagementTools -Verbose; powershell.exe -ExecutionPolicy Unrestricted -File framwork48_install_script.ps1 ; powershell.exe Restart-Computer -Force"
  }
SETTINGS
}
*/