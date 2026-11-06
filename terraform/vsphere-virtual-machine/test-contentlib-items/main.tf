##################################################################################
# PROVIDERS
##################################################################################

provider "vsphere" {
  vsphere_server       = var.vsphere_server
  user                 = var.vsphere_username
  password             = var.vsphere_password
  allow_unverified_ssl = var.vsphere_insecure
}

##################################################################################
# DATA SOURCES
##################################################################################

data "vsphere_datacenter" "datacenter" {
  name = var.vsphere_datacenter
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_resource_pool" "pool" {
  name          = format("%s%s", data.vsphere_compute_cluster.cluster.name, "/Resources")
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_content_library" "library" {
    name = var.vsphere_content_library
}

data "vsphere_content_library_items" "templates" {
 name       = "TinyVM"
 library_id = data.vsphere_content_library.library.id
 type       = "ovf"
}

locals {
  template_id = length(data.vsphere_content_library_items.templates.items) > 0 ? data.vsphere_content_library_items.templates.items[0].id : null
}

resource "vsphere_virtual_machine" "web" {
 name             = "web-server-01"
 resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
 datastore_id     = data.vsphere_datastore.datastore.id
 num_cpus         = 4   
 memory           = 8192

 network_interface {
   network_id = data.vsphere_network.network.id
 }

 disk {
   label = "disk0"
   size  = 50
 }

  dynamic "clone" {
    for_each = local.template_id != null ? [1] : []
    content {
      template_uuid = local.template_id
    }
  }

  lifecycle {
    ignore_changes = [clone]
  }
}

output "vm_name" {
   value = vsphere_virtual_machine.web.name
}

output "template_id" {
   value = local.template_id
}
