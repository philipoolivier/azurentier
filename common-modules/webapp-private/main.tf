// common-modules/webapp-private/main.tf

resource "azurerm_service_plan" "plan" {
  name                = var.plan_name
  resource_group_name = var.resource_group_name
  location            = var.location

  # required top-level args in 3.x provider:
  os_type  = var.os_type
  sku_name = var.sku_name
}

resource "azurerm_app_service" "app" {
  name                = var.webapp_name
  resource_group_name = var.resource_group_name
  location            = var.location
  app_service_plan_id = azurerm_service_plan.plan.id

  site_config {
    default_documents = ["index.html"]
  }
}

resource "azurerm_private_endpoint" "pe" {
  name                = var.private_endpoint_name
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = var.connection_name
    private_connection_resource_id = azurerm_app_service.app.id
    subresource_names              = var.subresource_names
    is_manual_connection           = var.is_manual_connection
  }
}
