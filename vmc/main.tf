provider vmc {
  refresh_token = var.api_token
  org_id = var.org_id
}

data "vmc_connected_accounts" "my_accounts" {
  account_number = var.aws_account_number
}

resource "vmc_sddc" "sddc_1" {
  sddc_name           = var.sddc_name
  vpc_cidr            = var.vpc_cidr
  num_host            = var.num_host
  provider_type       = "ZEROCLOUD"
  region              = var.sddc_region
  vxlan_subnet        = var.vxlan_subnet
  delay_account_link  = false
  skip_creating_vxlan = false

  deployment_type     = "SingleAZ"

  timeouts {
    create = "300m"
    update = "300m"
    delete = "180m"
  }

}