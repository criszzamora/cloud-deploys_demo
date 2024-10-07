# Provider
provider "azurerm" {
  features {}

  # Auth values
  subscription_id = ""
  client_id       = ""
  client_secret   = ""
  tenant_id       = ""
}

# Resource group
resource "azurerm_resource_group" "practice" {
  name     = "D-PracticeEnv"
  location = "eastus2"
}

# Active Directory Group
resource "azuread_group" "example_ad_group" {
  display_name     = "Reader-Only-Group"
  security_enabled = true
}

# Virtual Machine
resource "azurerm_virtual_network" "example_vnet" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.practice.location
  resource_group_name = azurerm_resource_group.practice.name
}

resource "azurerm_subnet" "example_subnet" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.practice.name
  virtual_network_name = azurerm_virtual_network.example_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "example_nic" {
  name                = "example-nic"
  location            = azurerm_resource_group.practice.location
  resource_group_name = azurerm_resource_group.practice.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "example_vm" {
  name                  = "example-vm"
  location              = azurerm_resource_group.practice.location
  resource_group_name   = azurerm_resource_group.practice.name
  network_interface_ids = [azurerm_network_interface.example_nic.id]
  vm_size               = "Standard_B2s"

  storage_os_disk {
    name              = "example-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "adminuser"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

# Reader role for AD Group
resource "azurerm_role_assignment" "example_role_assignment" {
  principal_id   = azuread_group.example_ad_group.object_id
  role_definition_name = "Reader"
  scope          = azurerm_resource_group.practice.id
}
