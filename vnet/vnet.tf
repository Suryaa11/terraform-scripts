terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.71.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}

resource "azurerm_resource_group" "rg" {
  name = var.resource_group.name
  location = var.resource_group.location
}

resource "azurerm_virtual_network" "vnet" {
  name = var.vnet.name
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space = var.vnet.address_space
}

resource "azurerm_subnet" "subnet" {
  name = var.subnet.name
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = var.subnet.address_prefixes
}

resource "azurerm_public_ip" "ip" {
  name = var.publicip.name
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method = var.publicip.allocation_method
  sku = var.publicip.sku
}

resource "azurerm_network_interface" "nic" {
  name = var.nic.name
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name = var.nic.ip_configuration
    subnet_id = azurerm_subnet.subnet.id
    private_ip_address_allocation = var.nic.private_ip_address_allocation
    public_ip_address_id = azurerm_public_ip.ip.id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name = var.vm.name
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  size = var.vm.size
  admin_username = var.vm.admin_username
  admin_password = var.vm.admin_password
  disable_password_authentication = var.vm.disable_password_authentication
  network_interface_ids = [azurerm_network_interface.nic.id]
  os_disk {
    caching = var.vm.os_disk.caching
    storage_account_type = var.vm.os_disk.storage_account_type
  }
  source_image_reference {
    publisher = var.vm.source_image_reference.publisher
    offer = var.vm.source_image_reference.offer
    sku = var.vm.source_image_reference.sku
    version = var.vm.source_image_reference.version
  }

}

resource "azurerm_network_security_group" "nsg" {
  name = var.nsg.name
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  security_rule {
    name = "ssh"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "22"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_ass" {
  subnet_id = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

