############################################################
# Application Gateway module — resources
############################################################

# Public IP ------------------------------------------------
resource "azurerm_public_ip" "pip" {
  name                = var.public_ip_name
  resource_group_name = var.resource_group_name
  location            = var.location

  allocation_method = "Static"
  sku               = "Standard"
}

# Application Gateway -------------------------------------
resource "azurerm_application_gateway" "this" {
  name                = var.gateway_name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = var.sku_name
    tier     = var.sku_tier
    capacity = var.sku_capacity
  }

  gateway_ip_configuration {
    name      = "gw-ip"
    subnet_id = var.subnet_id
  }

  frontend_ip_configuration {
    name                 = "frontend-ip"
    public_ip_address_id = azurerm_public_ip.pip.id
  }

  frontend_port {
    name = "frontend-port"
    port = var.frontend_port
  }

  backend_address_pool {
    name         = var.backend_pool_name
    ip_addresses = var.backend_ip_addresses
  }

  # Custom probe that uses correct Host header -------------
  probe {
    name                = "webapp-probe"
    protocol            = "Http"
    path                = "/"
    host                = var.backend_host_name
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
  }

  # Backend HTTP settings with host-name override -----------
  backend_http_settings {
    name                          = "http-settings"
    protocol                      = "Http"
    port                          = var.frontend_port
    request_timeout               = 30
    cookie_based_affinity         = "Disabled"

    # correct attribute name in provider v3.x:
    pick_host_name_from_backend_address = false
    host_name                           = var.backend_host_name

    probe_name                    = "webapp-probe"
  }

  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = "frontend-ip"
    frontend_port_name             = "frontend-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "http-listener"
    backend_address_pool_name  = var.backend_pool_name
    backend_http_settings_name = "http-settings"
    priority                   = var.rule_priority
  }
}
