variable api_token {
}
variable org_id {
}
variable aws_account_number {
}
variable num_host {
  default = "3"
}
variable sddc_name {    
  default = "Terraform-SDDC"
}
variable sddc_region {
  default = "US_WEST_1"
}
variable vpc_cidr {
  default = "172.31.48.0/20"
}
variable vxlan_subnet {
  default = "192.168.1.0/24"
}