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
  maximum_sessions_allowed = 10
  load_balancer_type       = "DepthFirst"
}

# Create a WVD Workspace
resource "azurerm_virtual_desktop_workspace" "workspace" {
  name                = "workspace"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  friendly_name = "FriendlyName"
  description   = "A description of my workspace"
}

