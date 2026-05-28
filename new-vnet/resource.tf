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
  name = var.rg.name
  location = var.rg.location  
}

resource "azurerm_virtual_network" "vnet" {
  name = var.vnet.name
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  address_space = var.vnet.address_space
}

resource "azurerm_subnet" "public_subnet" {
  name = var.public_subnet.name
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = var.public_subnet.address_prefixes
}

resource "azurerm_public_ip" "public_ip" {
  name = var.public_ip.name
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  allocation_method = var.public_ip.allocation_method
  sku = var.public_ip.sku
}

resource "azurerm_network_interface" "public_nic" {
  name = var.public_nic.name
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  ip_configuration {
    name = var.public_nic.ip_configuration.name
    subnet_id = azurerm_subnet.public_subnet.id
    private_ip_address_allocation = var.public_nic.ip_configuration.private_ip_address_allocation
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "public_vm" {
  name = var.public_vm.name
  size = var.public_vm.size
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  admin_username = var.public_vm.admin_username
  admin_password = var.public_vm.admin_password
  disable_password_authentication = var.public_vm.disable_password_authentication
  network_interface_ids = [azurerm_network_interface.public_nic.id]
  os_disk {
    caching = var.public_vm.os_disk.caching
    storage_account_type = var.public_vm.os_disk.storage_account_type
  }
  source_image_reference {
    publisher = var.public_vm.source_image_reference.publisher
    offer = var.public_vm.source_image_reference.offer
    sku = var.public_vm.source_image_reference.sku
    version = var.public_vm.source_image_reference.version
  }
}

resource "azurerm_network_security_group" "public_nsg" {
  name = var.public_nsg.name
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  security_rule {
    name = var.public_nsg.security_rule.name
    priority = var.public_nsg.security_rule.priority
    direction = var.public_nsg.security_rule.direction
    access = var.public_nsg.security_rule.access
    protocol = var.public_nsg.security_rule.protocol
    source_port_range = var.public_nsg.security_rule.source_port_range
    destination_port_range = var.public_nsg.security_rule.destination_port_range
    source_address_prefix = var.public_nsg.security_rule.source_address_prefix
    destination_address_prefix = var.public_nsg.security_rule.destination_address_prefix
  }
  security_rule {
    name = var.public_nsg.security_rule_1.name
    priority = var.public_nsg.security_rule_1.priority
    direction = var.public_nsg.security_rule_1.direction
    access = var.public_nsg.security_rule_1.access
    protocol = var.public_nsg.security_rule_1.protocol
    source_port_range = var.public_nsg.security_rule_1.source_port_range
    destination_port_range = var.public_nsg.security_rule_1.destination_port_range
    source_address_prefix = var.public_nsg.security_rule_1.source_address_prefix
    destination_address_prefix = var.public_nsg.security_rule_1.destination_address_prefix
  }
  security_rule {
    name = var.public_nsg.security_rule_2.name
    priority = var.public_nsg.security_rule_2.priority
    direction = var.public_nsg.security_rule_2.direction
    access = var.public_nsg.security_rule_2.access
    protocol = var.public_nsg.security_rule_2.protocol
    source_port_range = var.public_nsg.security_rule_2.source_port_range
    destination_port_range = var.public_nsg.security_rule_2.destination_port_range
    source_address_prefix = var.public_nsg.security_rule_2.source_address_prefix
    destination_address_prefix = var.public_nsg.security_rule_2.destination_address_prefix
  }
}

resource "azurerm_subnet_network_security_group_association" "public_nsg_ass" {
  subnet_id = azurerm_subnet.public_subnet.id
  network_security_group_id = azurerm_network_security_group.public_nsg.id
}

resource "azurerm_subnet" "private_subnet" {
  name = var.private_subnet.name
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = var.private_subnet.address_prefixes
}

resource "azurerm_network_interface" "private_nic" {
  name = var.private_nic.name
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  ip_configuration {
    name = var.private_nic.ip_configuration.name
    subnet_id = azurerm_subnet.private_subnet.id
    private_ip_address_allocation = var.private_nic.ip_configuration.private_ip_address_allocation
  }
}

resource "azurerm_public_ip" "nat_public_ip" {
  name = var.nat_public_ip.name
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  allocation_method = var.nat_public_ip.allocation_method
  sku = var.nat_public_ip.sku
}

resource "azurerm_nat_gateway" "nat_gateway" {
  name = var.nat_gateway.name
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  sku_name = var.nat_gateway.sku_name
}

resource "azurerm_nat_gateway_public_ip_association" "nat_ass_ip" {
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
  public_ip_address_id = azurerm_public_ip.nat_public_ip.id
}

resource "azurerm_subnet_nat_gateway_association" "nat_ass_subnet" {
  subnet_id = azurerm_subnet.private_subnet.id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}

resource "azurerm_linux_virtual_machine" "private_vm" {
  name = var.private_vm.name
  size = var.private_vm.size
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  admin_username = var.private_vm.admin_username
  admin_password = var.private_vm.admin_password
  disable_password_authentication = var.private_vm.disable_password_authentication
  network_interface_ids = [azurerm_network_interface.private_nic.id]
  custom_data = base64encode(file("app.sh"))
  os_disk {
    caching = var.private_vm.os_disk.caching
    storage_account_type = var.private_vm.os_disk.storage_account_type
  }
  source_image_reference {
    publisher = var.private_vm.source_image_reference.publisher
    offer = var.private_vm.source_image_reference.offer
    sku = var.private_vm.source_image_reference.sku
    version = var.private_vm.source_image_reference.version
  }
}

resource "azurerm_network_security_group" "private_nsg" {
  name = var.private_nsg.name
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  security_rule {
    name = var.private_nsg.security_rule.name
    priority = var.private_nsg.security_rule.priority
    direction = var.private_nsg.security_rule.direction
    access = var.private_nsg.security_rule.access
    protocol = var.private_nsg.security_rule.protocol
    source_port_range = var.private_nsg.security_rule.source_port_range
    destination_port_range = var.private_nsg.security_rule.destination_port_range
    source_address_prefix = var.private_nsg.security_rule.source_address_prefix
    destination_address_prefix = var.private_nsg.security_rule.destination_address_prefix
  }
}

resource "azurerm_subnet_network_security_group_association" "private_nsg_ass" {
  subnet_id = azurerm_subnet.private_subnet.id
  network_security_group_id = azurerm_network_security_group.private_nsg.id
}

resource "azurerm_public_ip" "lb_ip" {
  name = var.lb_ip.name
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  allocation_method = var.lb_ip.allocation_method
  sku = var.lb_ip.sku
}

resource "azurerm_lb" "lb" {
  name = var.lb.name
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  sku = var.lb.sku
  frontend_ip_configuration {
    name = var.lb.frontend_ip_configuration.name
    public_ip_address_id = azurerm_public_ip.lb_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  name = var.backend_pool.name
  loadbalancer_id = azurerm_lb.lb.id
}

resource "azurerm_lb_backend_address_pool_address" "backend_address" {
  name = var.backend_address.name
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
  virtual_network_id = azurerm_virtual_network.vnet.id
  ip_address = azurerm_network_interface.private_nic.private_ip_address
}

resource "azurerm_lb_rule" "lb_rule" {
  name = var.lb_rule.name
  loadbalancer_id = azurerm_lb.lb.id
  protocol = var.lb_rule.protocol
  frontend_port = var.lb_rule.frontend_port
  backend_port = var.lb_rule.backend_port
  frontend_ip_configuration_name = var.lb.frontend_ip_configuration.name
  probe_id = azurerm_lb_probe.lb_probe.id
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.backend_pool.id]
}

resource "azurerm_lb_probe" "lb_probe" {
  loadbalancer_id = azurerm_lb.lb.id
  name = var.lb_probe.name
  port = var.lb_probe.port
}
