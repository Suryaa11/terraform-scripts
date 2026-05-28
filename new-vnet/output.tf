output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "virtual_network_name" {
  value = azurerm_virtual_network.vnet.name
}

output "public_vm_public_ip" {
  value = azurerm_public_ip.public_ip.ip_address
}

output "public_vm_private_ip" {
  value = azurerm_network_interface.public_nic.private_ip_address
}

output "private_vm_private_ip" {
  value = azurerm_network_interface.private_nic.private_ip_address
}

output "nat_gateway_public_ip" {
  value = azurerm_public_ip.nat_public_ip.ip_address
}

output "load_balancer_public_ip" {
  value = azurerm_public_ip.lb_ip.ip_address
}
