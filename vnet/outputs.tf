output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "virtual_network_name" {
  value = azurerm_virtual_network.vnet.name
}

output "subnet_name" {
  value = azurerm_subnet.subnet.name
}

output "vm_name" {
  value = azurerm_linux_virtual_machine.vm.name
}

output "public_ip_address" {
  value = azurerm_public_ip.ip.ip_address
}

output "private_ip_address" {
  value = azurerm_network_interface.nic.private_ip_address
}

output "network_security_group_name" {
  value = azurerm_network_security_group.nsg.name
}