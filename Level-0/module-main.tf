// Level-0/main.tf

terraform {
  required_version = ">= 1.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  # Backend must be configured at init time (via -backend-config)
}

provider "azurerm" {
  features {}
}

# 1) Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.region
  tags     = var.tagvalue
}

# 2) Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name[0]
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.region
  address_space       = var.vnet_address
}

# 3) Generic Subnets (Web, App, DB, etc.)
resource "azurerm_subnet" "subnets" {
  for_each             = { for idx, name in var.subnet_names : name => idx }
  name                 = each.key
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [ var.subnet_range[each.value] ]
}

# 4) Application Gateway Subnet
resource "azurerm_subnet" "appgw" {
  name                 = var.subnet_appgw_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [ var.subnet_appgw_range ]
}

# ──────────────────────────────────────────────
# Private DNS zone + VNet link for Web Apps
# Paste the block right here ⬇︎
locals {
  dns_rg = var.private_dns_zone_rg_name != "" ? var.private_dns_zone_rg_name : var.resource_group_name
}

resource "azurerm_private_dns_zone" "webapp" {
  count               = var.create_private_dns_zone ? 1 : 0
  name                = "privatelink.azurewebsites.net"
  resource_group_name = local.dns_rg
}

resource "azurerm_private_dns_zone_virtual_network_link" "webapp_link" {
  count                 = var.create_private_dns_zone ? 1 : 0
  name                  = "vnet-link"
  resource_group_name   = local.dns_rg
  private_dns_zone_name = azurerm_private_dns_zone.webapp[0].name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = false
}
# ──────────────────────────────────────────────

# 5) Network Security Groups
resource "azurerm_network_security_group" "nsgs" {
  for_each            = toset(var.nsg_names)
  name                = each.key
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name

  # example single rule; add more blocks or convert to dynamic as needed
  security_rule {
    name                       = var.nsg_tier1_rules[0]
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tagvalue
}

# 6) Associate each NSG to its matching generic subnet
resource "azurerm_subnet_network_security_group_association" "assoc" {
  for_each                  = toset(var.subnet_names)
  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.nsgs[each.key].id
}


# Allow only the App Gateway subnet to reach the Web subnet on HTTP/HTTPS
resource "azurerm_network_security_rule" "web_allow_appgw_http_https" {
  name                        = "Allow-AppGw-HTTP-HTTPS"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"

  source_address_prefixes     = [var.subnet_appgw_range]       # App GW subnet CIDR
  source_port_range           = "*"
  destination_port_ranges     = ["80", "443"]

  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsgs["Web"].name
}
