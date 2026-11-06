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

data "vsphere_virtual_machines" "results" {
  folder	= var.vsphere_template_folder
  name_regex    = var.vsphere_template
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_content_library" "library" {
    name = var.vsphere_content_library
}

data "vsphere_content_library_items" "results" {
  name       = var.vsphere_template
  type       = "vm-template"
  library_id = data.vsphere_content_library.library.id
}

data "vsphere_virtual_machine" "template" {
  count = local.template_vm_uuid != null ? 1 : 0
  name  = var.vsphere_template
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

locals {
 template_content_uuid = var.is_contentlib_template ? data.vsphere_content_library_items.results.items[0].id : null
 template_vm_uuid      = !var.is_contentlib_template && length(data.vsphere_virtual_machines.results.virtual_machines) > 0 ? data.vsphere_virtual_machines.results.virtual_machines[0].id : null

 #template_uuid = var.is_contentlib_template ? data.vsphere_content_library_items.results.items[0].id : data.vsphere_virtual_machines.results.items[0].id
}

output "templates" {
   value = data.vsphere_virtual_machines.results.virtual_machines
}

output "vm_template" {
   value = local.template_vm_uuid != null ? data.vsphere_virtual_machine.template : null
}
##################################################################################
# RESOURCES
##################################################################################

/*resource "vsphere_virtual_machine" "rhel" {
  name                    = var.vm_name
  folder                  = var.vsphere_folder
  num_cpus                = var.vm_cpus
  memory                  = var.vm_memory
  firmware                = var.vm_firmware
  efi_secure_boot_enabled = var.vm_efi_secure_boot_enabled
  guest_id                = data.vsphere_virtual_machine.template.guest_id
  datastore_id            = data.vsphere_datastore.datastore.id
  resource_pool_id        = data.vsphere_resource_pool.pool.id

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks[0].size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks[0].eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks[0].thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name = var.vm_hostname
        domain    = var.vm_domain
      }
      network_interface {
        ipv4_address = var.vm_ipv4_address
        ipv4_netmask = var.vm_ipv4_netmask
      }
      ipv4_gateway    = var.vm_ipv4_gateway
      dns_suffix_list = var.vm_dns_suffix_list
      dns_server_list = var.vm_dns_server_list
    }
  }

  lifecycle {
    ignore_changes = [
      clone[0].template_uuid,
    ]
  }
}
*/

##################################################################################
# OUTPUTS
##################################################################################

/*output "vm_name" {
  value       = vsphere_virtual_machine.rhel.name
  description = "The name of the deployed RHEL virtual machine."
}

output "vm_ip_address" {
  value       = vsphere_virtual_machine.rhel.default_ip_address
  description = "The IP address of the deployed RHEL virtual machine."
}

output "vm_moid" {
  value       = vsphere_virtual_machine.rhel.moid
  description = "The managed object ID of the deployed RHEL virtual machine."
}
*/
