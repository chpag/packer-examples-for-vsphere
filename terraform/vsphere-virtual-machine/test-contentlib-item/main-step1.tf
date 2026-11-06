# STEP 1 — initial deploy
# Run: terraform apply
# Then delete TinyVM manually in vCenter
# Then: terraform state rm vsphere_content_library_item.tinyvm
# Then switch to main-step2.tf

resource "vsphere_content_library" "lib" {
  name            = "repro-library"
  storage_backing = [data.vsphere_datastore.ds.id]
}

resource "vsphere_content_library_item" "tinyvm" {
  name       = "TinyVM"
  library_id = vsphere_content_library.lib.id
  type       = "ovf"
  file_url   = "https://storage.googleapis.com/vsphere-acctest/TinyVM/TinyVM.ova"
}

data "vsphere_content_library_item" "template" {
  name       = vsphere_content_library_item.tinyvm.name
  library_id = vsphere_content_library.lib.id
  type       = "ovf"
}

locals {
  template_id = data.vsphere_content_library_item.template.id
}

resource "vsphere_virtual_machine" "web" {
  name             = "repro-vm-01"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.ds.id
  num_cpus         = 2
  memory           = 1024
  guest_id         = "other3xLinuxGuest"

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label = "disk0"
    size  = 20
  }

  clone {
    template_uuid = local.template_id
  }

  lifecycle {
    ignore_changes = [clone]
  }
}
