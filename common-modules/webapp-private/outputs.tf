output "private_endpoint_ip" {
  description = "Private IP of the Web App"
  value       = azurerm_private_endpoint.pe.private_service_connection[0].private_ip_address
}

output "app_service_id" {
  description = "ID of the App Service"
  value       = azurerm_app_service.app.id
}
