// Level-0/output.tf

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "virtual_network_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.vnet.id
}

output "subnet_ids" {
  description = "IDs of the generic subnets (Web, App, DB)"
  value       = [for s in azurerm_subnet.subnets : s.id]
}

output "appgw_subnet_id" {
  description = "ID of the Application Gateway subnet"
  value       = azurerm_subnet.appgw.id
}

output "nsg_ids" {
  description = "IDs of all NSGs"
  value       = [for n in azurerm_network_security_group.nsgs : n.id]
}

output "webapp_private_dns_zone_id" {
  description = "ID of the privatelink.azurewebsites.net zone"
  value       = length(azurerm_private_dns_zone.webapp) > 0 ? azurerm_private_dns_zone.webapp[0].id : null
}

