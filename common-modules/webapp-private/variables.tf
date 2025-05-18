// common-modules/webapp-private/variables.tf

variable "resource_group_name" {
  description = "Target resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the private endpoint"
  type        = string
}

variable "plan_name" {
  description = "Name for the Service Plan"
  type        = string
}

variable "sku_name" {
  description = "SKU name for the Service Plan (e.g., S1, S2, P1V2)"
  type        = string
}

variable "os_type" {
  description = "Operating system type for the plan (Windows or Linux)"
  type        = string
}

variable "webapp_name" {
  description = "Name for the Web App"
  type        = string
}

variable "private_endpoint_name" {
  description = "Name for the Private Endpoint"
  type        = string
}

variable "connection_name" {
  description = "Private Service Connection name"
  type        = string
}

variable "subresource_names" {
  description = "List of subresource names (usually [\"sites\"])"
  type        = list(string)
  default     = ["sites"]
}

variable "is_manual_connection" {
  description = "If true, the private endpoint connection is manual"
  type        = bool
  default     = false
}
