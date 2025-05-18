###############################################################################
# Level-1 · variables.tf
# (All variables required by main.tf and the common-modules)
###############################################################################

########################
# Core / networking
########################
variable "resource_group_name" {
  description = "Resource Group created in Level-0"
  type        = string
}

variable "region" {
  description = "Azure region where Level-1 resources live (e.g. australiaeast)"
  type        = string
}

variable "vnet_name" {
  description = "Single-item list containing the Level-0 VNet name"
  type        = list(string)
}

variable "subnet_web_name" {
  description = "Subnet that hosts the Web-App Private Endpoint"
  type        = string
}

variable "subnet_appgw_name" {
  description = "Subnet that hosts the Application Gateway"
  type        = string
}

########################
# Linux App-Service Plan
########################
variable "webapp_plan_name" {
  description = "Name for the Linux App-Service Plan"
  type        = string
}

variable "webapp_plan_sku_name" {
  description = "SKU name for the plan (e.g. B1, S1, P1v2)"
  type        = string
}

########################
# Linux Web-App
########################
variable "webapp_name" {
  description = "Name for the Linux Web-App"
  type        = string
}

########################
# Private Endpoint
########################
variable "webapp_pe_name" {
  description = "Name for the Web-App Private Endpoint"
  type        = string
}

variable "webapp_pe_connection_name" {
  description = "Name of the private-service-connection inside the PE"
  type        = string
}

########################
# Application Gateway
########################
variable "appgw_public_ip_name" {
  description = "Name for the public IP attached to the Application Gateway"
  type        = string
}

variable "appgw_name" {
  description = "Name for the Application Gateway"
  type        = string
}

variable "appgw_sku_name" {
  description = "SKU name for the AGW (e.g. Standard_v2, WAF_v2)"
  type        = string
}

variable "appgw_sku_tier" {
  description = "SKU tier (must match appgw_sku_name)"
  type        = string
}

variable "appgw_sku_capacity" {
  description = "Instance count for the AGW (1-125 for v2 SKUs)"
  type        = number
}

variable "appgw_frontend_port" {
  description = "Port used by the AGW HTTP listener (typically 80 or 443)"
  type        = number
}
