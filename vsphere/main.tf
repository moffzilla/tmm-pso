provider "vsphere" {
  #user           = var.vsphere_user
  #password       = var.vsphere_password
  #vsphere_server = var.vsphere_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "RegionA01"
}

data "vsphere_datastore" "datastore" {
  name          = "RegionA01-ISCSI02-COMP01"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = "pks-comp-1"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "VM-RegionA01-vDS-COMP"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Retrieve template information on vsphere
data "vsphere_virtual_machine" "template" {
  name          = "ubuntu1804bis"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "vm" {
  name             = "terraform-test"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus = 2
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label = "disk0"
    size  = 20
  }
}
