provider "azurerm" {
    # The "feature" block is required for AzureRM provider 2.x. 
    # If you're using version 1.x, the "features" block is not allowed.
    version = "~>2.0"
    features {}
}

resource "azurerm_mssql_firewall_rule" "example" {
  name             = "FirewallRule1"
  server_id        = var.mssql_server
  start_ip_address = var.starip
  end_ip_address   = var.endip
}
