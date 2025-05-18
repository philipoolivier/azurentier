############################################################
# Application Gateway module — outputs
############################################################

output "application_gateway_id" {
  description = "ID of the Application Gateway"
  value       = azurerm_application_gateway.this.id
}

output "public_ip_id" {
  description = "ID of the public IP"
  value       = azurerm_public_ip.pip.id
}
