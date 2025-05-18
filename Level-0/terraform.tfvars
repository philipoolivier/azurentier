environment            = "dev"
region                 = "australiaeast"
resource_group_name    = "azure-n-tier"

vnet_name              = ["cloud-engg-project1"]
vnet_address           = ["10.100.0.0/16"]

subnet_names           = ["Web","App","DB"]
subnet_range           = ["10.100.0.0/24","10.100.1.0/24","10.100.2.0/24"]





subnet_appgw_name      = "App-GW"
subnet_appgw_range     = "10.100.5.0/24"



nsg_names              = ["Web","App","DB"]
nsg_tier1_rules        = ["Allow_Port80_Inbound","Allow_Port443_Inbound","Allow_Port3389_Inbound","Deny_Virtualnetwork_Inbound"]
nsg_tier2_rules        = ["Deny_Virtualnetwork_Inbound","Allow_Azuremonitor_Outbound","Deny_Internet_Outbound"]
nsg_tier3_rules        = ["Deny_Virtualnetwork_Inbound","Allow_Azuremonitor_Outbound","Deny_Internet_Outbound"]

tagvalue = {
  environment = "Development"
}
