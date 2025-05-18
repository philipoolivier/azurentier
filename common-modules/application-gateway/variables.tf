############################################################
# Application Gateway module — input variables
############################################################

variable "resource_group_name" {
  description = "Target Resource Group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the Application Gateway lives"
  type        = string
}

variable "public_ip_name" {
  description = "Name for the Public IP"
  type        = string
}

variable "gateway_name" {
  description = "Name for the Application Gateway"
  type        = string
}

variable "sku_name" {
  description = "SKU name, e.g. Standard_v2, WAF_v2"
  type        = string
}

variable "sku_tier" {
  description = "SKU tier, must match sku_name"
  type        = string
}

variable "sku_capacity" {
  description = "Instance count for the Application Gateway"
  type        = number
}

variable "frontend_port" {
  description = "Port the HTTP listener will use"
  type        = number
}

variable "backend_pool_name" {
  description = "Name for the backend address pool"
  type        = string
  default     = "backend-pool"
}

variable "backend_ip_addresses" {
  description = "List of backend IP addresses"
  type        = list(string)
  default     = []
}

variable "rule_priority" {
  description = "Priority (1-20000) for the basic request-routing rule"
  type        = number
  default     = 100
}

# NEW — host header required by the Web App
variable "backend_host_name" {
  description = "Host header to send to the backend (webapp_name.azurewebsites.net)"
  type        = string
}
