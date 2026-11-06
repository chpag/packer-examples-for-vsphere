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

data "vsphere_content_library" "library" {
    name = var.vsphere_content_library
}

resource "vsphere_content_library_item" "TinyVM" {
 name       = "TinyVM"
 library_id = data.vsphere_content_library.library.id
 type       = "ovf"
 file_url   = var.tinyvm_url
}

