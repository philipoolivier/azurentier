###############################################################################
# Level-1 • terraform.tfvars
# Edit the values to match your environment.
###############################################################################

# Core / network
resource_group_name = "azure-n-tier"
region              = "australiaeast"

vnet_name           = ["cloud-engg-project1"]
subnet_web_name     = "Web"
subnet_appgw_name   = "app-gw"

# App-Service Plan & Web-App
webapp_plan_name     = "webapp-plan"
webapp_plan_sku_name = "S1"
webapp_name          = "mywebappsite1234"

# Private Endpoint
webapp_pe_name            = "pe-webapp"
webapp_pe_connection_name = "psc-webapp"

# Application Gateway
appgw_public_ip_name = "appgw-pip"
appgw_name           = "appgw"
appgw_sku_name       = "Standard_v2"
appgw_sku_tier       = "Standard_v2"
appgw_sku_capacity   = 2
appgw_frontend_port  = 80
