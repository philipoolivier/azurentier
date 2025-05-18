###############################################################################
# Level-1 • main.tf
# Deploys:
#   • Linux App-Service plan
#   • Linux Web-App (private only, hello-world sample)
#   • Private Endpoint into the Web subnet
#   • Application Gateway that fronts the Web-App
###############################################################################

terraform {
  required_version = ">= 1.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

########################
# Look-ups from Level-0
########################
data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name[0]
  resource_group_name = var.resource_group_name
}

data "azurerm_subnet" "web" {
  name                 = var.subnet_web_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
}

data "azurerm_subnet" "appgw" {
  name                 = var.subnet_appgw_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
}

# Private-DNS zone created in Level-0
data "azurerm_private_dns_zone" "webapp_zone" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = var.resource_group_name
}

########################
# Linux App-Service Plan
########################
resource "azurerm_service_plan" "plan" {
  name                = var.webapp_plan_name
  resource_group_name = var.resource_group_name
  location            = var.region

  os_type  = "Linux"
  sku_name = var.webapp_plan_sku_name
}

########################
# Linux Web-App (hello-world)
########################
resource "azurerm_linux_web_app" "app" {
  name                = var.webapp_name
  resource_group_name = var.resource_group_name
  location            = var.region
  service_plan_id     = azurerm_service_plan.plan.id
  public_network_access_enabled = false

  site_config {
    application_stack {
      node_version = "18-lts"
    }
  }

  app_settings = {
    WEBSITE_RUN_FROM_PACKAGE = "https://github.com/Azure-Samples/nodejs-docs-hello-world/releases/latest/download/nodejs-docs-hello-world.zip"
  }
}

########################
# Private Endpoint
########################
resource "azurerm_private_endpoint" "pe" {
  name                = var.webapp_pe_name
  resource_group_name = var.resource_group_name
  location            = var.region
  subnet_id           = data.azurerm_subnet.web.id

  private_service_connection {
    name                           = var.webapp_pe_connection_name
    private_connection_resource_id = azurerm_linux_web_app.app.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.webapp_zone.id]
  }
}

########################
# Application Gateway
########################
module "app_gateway" {
  source               = "../common-modules/application-gateway"

  resource_group_name  = var.resource_group_name
  location             = var.region
  subnet_id            = data.azurerm_subnet.appgw.id

  public_ip_name       = var.appgw_public_ip_name
  gateway_name         = var.appgw_name
  sku_name             = var.appgw_sku_name
  sku_tier             = var.appgw_sku_tier
  sku_capacity         = var.appgw_sku_capacity
  frontend_port        = var.appgw_frontend_port

  # Host header AGW must send to Web-App
  backend_host_name    = azurerm_linux_web_app.app.default_hostname

  # Private IP from the PE
  backend_ip_addresses = [
    azurerm_private_endpoint.pe.private_service_connection[0].private_ip_address
  ]
}
