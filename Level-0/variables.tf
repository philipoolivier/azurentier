// Level-0/variables.tf

variable "environment" {
  description = "Name for the environment (e.g., dev, prod)"
  type        = string
}

variable "region" {
  description = "Azure region (e.g., southeastasia)"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group to create"
  type        = string
}

variable "vnet_name" {
  description = "List of virtual network names"
  type        = list(string)
}

variable "vnet_address" {
  description = "List of virtual network address spaces"
  type        = list(string)
}

variable "subnet_names" {
  description = "List of generic subnet names (Web, App, DB, etc.)"
  type        = list(string)
}

variable "subnet_range" {
  description = "List of CIDR ranges for generic subnets"
  type        = list(string)
}

variable "subnet_appgw_name" {
  description = "Name of the Application Gateway subnet"
  type        = string
}

variable "subnet_appgw_range" {
  description = "CIDR range for the Application Gateway subnet"
  type        = string
}

variable "nsg_names" {
  description = "List of NSG names, matching subnet_names"
  type        = list(string)
}

variable "nsg_tier1_rules" {
  description = "List of Tier-1 NSG rule names"
  type        = list(string)
}

variable "nsg_tier2_rules" {
  description = "List of Tier-2 NSG rule names"
  type        = list(string)
}

variable "nsg_tier3_rules" {
  description = "List of Tier-3 NSG rule names"
  type        = list(string)
}

variable "tagvalue" {
  description = "Map of tags to apply to all resources"
  type        = map(string)
}


variable "create_private_dns_zone" {
  description = "Whether to create the privatelink.azurewebsites.net zone"
  type        = bool
  default     = true
}

variable "private_dns_zone_rg_name" {
  description = "Resource-group for the private DNS zone (defaults to the main RG)"
  type        = string
  default     = ""
}
