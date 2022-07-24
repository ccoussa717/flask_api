# Provider Information
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.14.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Create Resource Group
resource "azurerm_resource_group" "resource_group" {
  name     = "Win10RG-resources"
  location = "East US"
}

# Create Security Group
resource "azurerm_network_security_group" "security_group" {
  name                = "Win10RG-security-group"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
}

# Create Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "Win10RG-network"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  address_space       = ["10.0.0.0/16"]
}

# Create a subnet for the network...you need a subnet for resources to connect to
resource "azurerm_subnet" "subnet1" {
  name                 = "Win10RG-subnet"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "vnet-interface" {
  name                = "vnet-nic"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

# Create Virtual Desktop Host Pool
resource "azurerm_virtual_desktop_host_pool" "host_pool1" {
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  name                     = "pool 1"
  friendly_name            = "pool 1"
  validate_environment     = true
  start_vm_on_connect      = true
  custom_rdp_properties    = "audiocapturemode:i:1;audiomode:i:0;"
  description              = "Acceptance Test: A pooled host pool - pooleddepthfirst"
  type                     = "Pooled"
  maximum_sessions_allowed = 5
  load_balancer_type       = "DepthFirst"
}

# Creat a Workspace (this is what will host the appications that the user will see when they log in to the WVD)
# desktop application group
resource "azurerm_virtual_desktop_workspace" "workspace" {
  name                = "workspace"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  friendly_name = "ws1"
  description   = "Windows 10 virtaul desktop environment"
}

resource "azurerm_virtual_desktop_application_group" "remoteapp" {
  name                = "Desktop"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  type         = "Desktop"
  host_pool_id = azurerm_virtual_desktop_host_pool.host_pool1.id
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "workspaceremoteapp" {
  workspace_id         = azurerm_virtual_desktop_workspace.workspace.id
  application_group_id = azurerm_virtual_desktop_application_group.remoteapp.id
}

# Virtual Machine for Web App Server
resource "azurerm_linux_virtual_machine" "WebServer" {
  name                = "WebServer"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  size                = "Standard_D2s_v3"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.vnet-interface.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "Latest"
  }

  depends_on = [
    azurerm_network_interface.vnet-interface
  ]
}
